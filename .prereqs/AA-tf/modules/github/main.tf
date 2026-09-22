# TODO:  take this out; it's just a hello-world to make sure I have the provider working before I insert any real work.
data "github_repository" "current_gh_repo" {
  name = var.current_gh_repo_name
  lifecycle {
    postcondition {
      condition     = (coalesce(self.name, "") == var.current_gh_repo_name)
      error_message = "GitHub current repo name is not as passed in."
    }
  }
}
