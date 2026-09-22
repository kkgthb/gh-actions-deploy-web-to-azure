# TODO:  take this out; it's just a hello-world to make sure I have the provider working before I insert any real work.
output "repo_full_name" {
  value = data.github_repository.current_gh_repo.full_name
}
