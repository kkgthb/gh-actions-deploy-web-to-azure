variable "entra_tenant_id" {
  type     = string
  nullable = false
}
variable "pizza_app_nonprod_az_sub_id" {
  type     = string
  nullable = false
}
variable "pizza_app_prod_az_sub_id" {
  type     = string
  nullable = false
}
# TODO:  make the variables more realistic; this is just a hello-world to make sure I have the provider working before I insert any real work.
variable "current_gh_repo_name" {
  type = string
}
