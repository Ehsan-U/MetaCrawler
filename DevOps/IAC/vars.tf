

# variable "pm_api_url" {
#   type = string
# }
  
# variable "pm_api_token_id" {
#     type = string
# }

# variable "pm_api_token_secret" {
#     type = string
#     sensitive = true
# }

variable "ssh_public_key" {
    type = string
    sensitive = true
}

variable "nodes" {
  type = list(string)
  default = [
    "master",
    "slave-1",
    "slave-2"
]
}



