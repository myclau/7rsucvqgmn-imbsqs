### Enable it if you have s3 to store the state file ###

/*terraform {
  backend "s3" {
    bucket = "xxx-terraform-state-store"
    key    = "terraform.tfstate"
    region = ""
    workspace_key_prefix = ""
    access_key= ""
    secret_key= ""
  }
}*/