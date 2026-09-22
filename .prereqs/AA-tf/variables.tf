variable "entra_tenant_id" {
  type     = string
  nullable = false
}
variable "az_sub_id" {
  type     = string
  nullable = false
}
variable "workload_nickname" {
  type     = string
  nullable = false
}
variable "current_gh_repo_name" {
  type     = string
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
variable "current_gh_repo_owner_type" {
  type     = string
  nullable = false
  validation {
    # Checks if the provided value exists inside the allowed array
    condition     = contains(["User", "Organization"], var.current_gh_repo_owner_type)
    error_message = "The current_gh_repo_owner_type must be one of: User, Organization."
  }
}
variable "current_gh_repo_owner_numeric_id" {
  type     = string
  nullable = false
  validation {
    condition     = can(regex("^[0-9]+$", var.current_gh_repo_owner_numeric_id))
    error_message = "The current_gh_repo_numeric_id variable must contain numbers/digits only."
  }
}
