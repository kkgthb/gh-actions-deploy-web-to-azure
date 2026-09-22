# GitHub Actions workflow that deploys a little web API to Azure Function Apps

The GitHub Actions workflow named `build-and-deploy.yml` compiles the code found in `src/web` into an executable runtime and then deploys that runtime up into Azure Functions.

## Deployment test cases

If building and deploying worked, then doing an HTTPS `GET` request to something like `https://your_azure_function_app_name_here.azurewebsites.net/api/helloWorld?name=you` should return a UTF-8 charset `text/plain` HTTPS response with a body of `Hello, you!` _(in general, the `name` query parameter should result in a customized body)_ and if you don't include a `name` parameter at all, it should fall back to `Hello, World!`.

## Prereqs

If you haven't set up Entra and Azure resources, or haven't yet configured your GitHub repo's "environment" and such correctly, then the GitHub Actions workflow named `build-and-deploy.yml` won't work right.

Note:  If you use my sample Terraform code in `.prereqs` to spin it all up, note that it puts mandatory review into the GitHub repo "environments" it creates.  So if your GitHub Actions workflow is waiting on you to approve deploy, well ... go do that.

### Manual prereqs checklist

For **each** of your environments like `nonprod` and `prod`:

* **Entra:** Create an app registration and corresponding service principal dedicated to representing the GitHub Actions workflow within Microsoft's clouds.  Add a federated credential with issuer `https://token.actions.githubusercontent.com`, audience `api://AzureADTokenExchange`, and a subject matching your repository and your GitHub environment _(see GitHub below for the environment part)_.
* **Azure:** Create a Linux Node.js 22 Function App and its storage account _(and grant the Function App appropriate permissions against its underlying storage account if necessary, using Azure RBAC Role Assignments)_.  Grant the Entra service principal mentioned above an Azure RBAC Role Assignment of `Website Contributor` scoped against the Function App, and another one of `Storage Blob Data Contributor` scoped against the storage account.
* **GitHub:** Create a GitHub "environment" corresponding to the Entra service principal and its matching deployment-target Azure resources _(that is, the Azure subscription containing the Azure resources against which the Entra service principal was granted `Website Contributor` and `Storage Blob Data Contributor`)_.  Into that GitHub "environment," create and fill in these environment secrets: `ENTRA_TENANT_ID`, `ENTRA_CLIENT_ID`, `AZURE_SUBSCRIPTION_ID`, and `AZURE_FUNCTIONAPP_NAME`.
    * Also, Either edit the `name` property under the `environment` property of the deploy jobs in `build-and-deploy.yml`, or, like I did, give your repo a repo-wide GitHub Actions named, say, `envpointer_nonprod` / `envpointer_prod` and make the value of that variable the name of your environment.
        * _(It doesn't matter which approach you take, and maybe hardcoding is better.  I just didn't want to hardcode certain distracting quirks about the way I chose to name my GitHub "environments" into `build-and-deploy.yml`, so in this demo, I hid some of those quirks from `build-and-deploy.yml` behind an extra variable.  My approach is probably way overengineered for an enterprise production scenario -- usually I just hardcode the `environment: name: ` value into the `.yml` file, honestly.)_
* **GitHub:** Configure any required GitHub "environment" reviewers that your business says you should be adding, then be sure to approve the deployment when the workflow pauses for review.
