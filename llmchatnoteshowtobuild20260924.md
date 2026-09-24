## User

> `dotnet publish "SOURCE_DIR_HERE" --configuration "SOMETHING_LIKE_THE_WORD_RELEASE" --output "TARGET_DIR_HERE"` seems to be all you need to do for a .NET-based Azure Function App, as best I can tell.  But I can't figure out what the correct flows are when you've got, say, a PowerShell Function App codebase in your `mypsfuncappsourcecode` folder of your root repo, or when you've got, say, a .NET Function App codebase in your `mynodefuncappsourcecode` folder of your root repo.

## LLM Response

The key is not “run one standard publish command for every Function App.” It’s: **build or stage each app’s deployable files, then point the deploy action at a directory whose root contains host.json.** Your current workflow already follows that pattern for Node: it builds into `dist`, uploads that artifact, and deploys the downloaded directory (build-and-deploy.yml, build-and-deploy.yml).

Assuming `mynodefuncappsourcecode` is actually the folder containing your .NET Function App:

### PowerShell Function App

PowerShell Functions generally **don’t need a compile/publish step**. Stage the project files and upload them. The package root should have host.json, with each function’s folder and its `function.json` and script beneath it. The Azure Functions docs’ GitHub Actions example likewise says PowerShell projects don’t require a build step.

```yaml
      - name: Stage PowerShell Function App
        shell: bash
        run: |
          mkdir -p "$RUNNER_TEMP/ps-function"
          rsync -a --exclude='local.settings.json' \
            "$GITHUB_WORKSPACE/mypsfuncappsourcecode/" \
            "$RUNNER_TEMP/ps-function/"
          test -f "$RUNNER_TEMP/ps-function/host.json"

      - uses: actions/upload-artifact@v7
        with:
          name: powershell-function
          path: ${{ runner.temp }}/ps-function
          if-no-files-found: error
```

Then download `powershell-function` into a directory and set the deploy step’s `package` to that directory—just as your current deploy steps do. Use a **Windows-hosted PowerShell Function App**; the CI runner itself can be Linux or Windows. Don’t include `local.settings.json` in the deployment package.

### .NET Function App

For .NET, run `dotnet publish` against the **project file** (`.csproj`) and upload the publish output. Replace the folder, project filename, and SDK version with those for your project:

```yaml
      - uses: actions/setup-dotnet@v5
        with:
          dotnet-version: '10.0.x' # Match the project's target framework / SDK needs

      - name: Publish .NET Function App
        run: |
          dotnet publish \
            "mynodefuncappsourcecode/MyFunctionApp.csproj" \
            --configuration Release \
            --output "$RUNNER_TEMP/dotnet-function"
          test -f "$RUNNER_TEMP/dotnet-function/host.json"

      - uses: actions/upload-artifact@v7
        with:
          name: dotnet-function
          path: ${{ runner.temp }}/dotnet-function
          include-hidden-files: true
          if-no-files-found: error
```

`include-hidden-files: true` matters for .NET publish output because it can contain required hidden deployment files such as `.azurefunctions`. The deployed package should be the **contents of the publish output**, not a parent folder that adds another level of nesting.

### How this fits your workflow

Keep the same build-once, deploy-to-nonprod, then deploy-the-same-artifact-to-prod structure. For each Function App, give its build output and artifact a distinct name, then have its deploy jobs download and deploy that artifact. If the repo has both PowerShell and .NET apps, use separate build/artifact paths and corresponding deploy jobs (or separate workflows); don’t send one app’s artifact to the other app.

Also ensure the Azure Function App’s OS and configured runtime match the app you deploy. Microsoft’s references: [GitHub Actions deployment](https://learn.microsoft.com/azure/azure-functions/functions-how-to-github-actions), [PowerShell project structure](https://learn.microsoft.com/azure/azure-functions/functions-reference-powershell#folder-structure), and [.NET isolated deployment payload](https://learn.microsoft.com/azure/azure-functions/dotnet-isolated-process-guide#deployment-payload).

---

## User

> Whoops I meant a NodeJS Function App codebase in the `mynodefuncappsourcecode` folder

## LLM Response

Got it—`mynodefuncappsourcecode` is a **Node.js** Function App, not .NET. In that case, ignore the `dotnet publish` flow. Node apps typically install dependencies, run any project build, and package the app files plus production dependencies.

Your current workflow already demonstrates this for the TypeScript app in web: it runs `npm ci`, builds to `dist`, installs production dependencies there, and uploads `dist` ([build steps](.github/workflows/build-and-deploy.yml#L31-L60)). For a TypeScript app with the same layout, adapt the project directory and artifact name:

```yaml
      - name: Install dependencies
        working-directory: ${{ github.workspace }}/mynodefuncappsourcecode
        run: npm ci

      - name: Build Function App
        working-directory: ${{ github.workspace }}/mynodefuncappsourcecode
        run: npm run build --if-present

      - name: Install production dependencies into package
        working-directory: ${{ github.workspace }}/mynodefuncappsourcecode
        run: |
          cp package-lock.json dist/package-lock.json
          npm ci --omit=dev --prefix dist

      - name: Upload Function App package
        uses: actions/upload-artifact@v7
        with:
          name: node-function
          path: ${{ github.workspace }}/mynodefuncappsourcecode/dist
          if-no-files-found: error
```

That assumes the build creates `dist` with host.json, package.json, and the app’s runtime files—just as your current build does. If it’s plain JavaScript with no build step, the package can instead be staged from the source directory, with production dependencies included. In either case, deploy the resulting package directory using the existing `package` input pattern ([deploy step](.github/workflows/build-and-deploy.yml#L89-L95)).