
# terraform {
#   required_providers {
#     proxmox = {
#       source = "Telmate/proxmox"
#       version = "2.9.14"
#     }
#   }
# }

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.83.0"
    }
  }
}


# provider "proxmox" {
#   pm_api_url = var.pm_api_url
#   pm_api_token_id = var.pm_api_token_id
#   pm_api_token_secret = var.pm_api_token_secret
  
#   pm_tls_insecure = true
# }

provider "google" {
  project     = "ethereal-anvil-391608"
  region      = "us-central1"
  credentials = file("secret.json")
}
