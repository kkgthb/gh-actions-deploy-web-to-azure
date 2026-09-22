# Reminder:  to run this Terraform code successfully, 
# you must be logged into the Azure CLI as an Entra principal that has adequate permissions to manipulate 
# both Azure and Entra.
# Furthermore, you must be logged into the GitHub CLI as a GitHub user that has adequate permissions 
# to manipulate this GitHub repo.

$gh_cli_logged_in_user = (gh auth status --active --json 'hosts' --jq '.hosts."github.com"[0].login')
$current_repo_owner_login = (gh repo view --json 'owner' --jq '.owner.login')
If ($gh_cli_logged_in_user -ne $current_repo_owner_login) {
    gh auth switch --user $current_repo_owner_login
}
$current_repo_name = (gh repo view --json 'name' --jq '.name')
$current_repo_numeric_id = (gh api "repos/$current_repo_owner_login/$current_repo_name" --jq '.id')
$current_repo_owner_type = (gh api "repos/$current_repo_owner_login/$current_repo_name" --jq '.owner.type')
$current_repo_owner_numeric_id = (gh api "repos/$current_repo_owner_login/$current_repo_name" --jq '.owner.id')

Push-Location("$PsScriptRoot")

terraform apply `
    -var entra_tenant_id="$([Environment]::GetEnvironmentVariable('DEMOS_my_entra_tenant_id', 'User'))" `
    -var az_sub_id="$([Environment]::GetEnvironmentVariable('DEMOS_my_azure_subscription_id', 'User'))" `
    -var workload_nickname="$([Environment]::GetEnvironmentVariable('DEMOS_my_workload_nickname', 'User'))" `
    -var current_gh_repo_name="$current_repo_name" `
    -var current_gh_repo_numeric_id="$current_repo_numeric_id" `
    -var current_gh_repo_owner_login="$current_repo_owner_login" `
    -var current_gh_repo_owner_type="$current_repo_owner_type" `
    -var current_gh_repo_owner_numeric_id="$current_repo_owner_numeric_id" `
    -input=false `
    -auto-approve

Pop-Location