variable "entra_tenant_id" {
  type     = string
  nullable = false
}
variable "expected_az_sub_id" {
  type     = string
  nullable = false
}
variable "workload_nickname" {
  type     = string
  nullable = false
}
variable "environment_nickname" {
  type     = string
  nullable = false
}
variable "current_gh_repo_name" {
  type = string
  nullable = false
}
variable "current_gh_repo_numeric_id" {
  type     = string
  nullable = false
  validation {
    condition     = can(regex("^[0-9]+$", var.current_gh_repo_numeric_id))
    error_message = "The current_gh_repo_numeric_id variable must contain numbers/digits only."
  }
}
variable "current_gh_repo_owner_login" {
  type     = string
  nullable = false
}
variable "current_gh_repo_owner_numeric_id" {
  type     = string
  nullable = false
  validation {
    condition     = can(regex("^[0-9]+$", var.current_gh_repo_owner_numeric_id))
    error_message = "The current_gh_repo_numeric_id variable must contain numbers/digits only."
  }
}
