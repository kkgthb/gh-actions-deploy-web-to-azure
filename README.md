# GitHub Actions workflow that deploys a little web API to Azure Function Apps

The GitHub Actions workflow named `build-and-deploy.yml` compiles the code found in `src/web` into an executable runtime and then deploys that runtime up into Azure Functions.

## Deployment test cases

If building and deploying worked, then doing an HTTPS `GET` request to something like `https://your_azure_function_app_name_here.azurewebsites.net/api/helloWorld?name=you` should return a UTF-8 charset `text/plain` HTTPS response with a body of `Hello, you!` _(in general, the `name` query parameter should result in a customized body)_ and if you don't include a `name` parameter at all, it should fall back to `Hello, World!`.

## Prereqs

If you haven't set up Entra and Azure resources, or haven't yet configured your GitHub repo's "environment" and such correctly, then the GitHub Actions workflow named `build-and-deploy.yml` won't work right.

Note:  If you use my sample Terraform code in `.prereqs` to spin it all up, note that it puts mandatory review into the GitHub repo "environments" it creates.  So if your GitHub Actions workflow is waiting on you to approve deploy, well ... go do that.
