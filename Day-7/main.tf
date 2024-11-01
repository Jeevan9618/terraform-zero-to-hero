provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://54.162.113.210:8300"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "<>"
      secret_id = "<>"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv" // change it according to your mount
  name  = "s3_name" // change it according to your secret
}


resource "aws_s3_bucket" "example" {
  bucket = data.vault_kv_secret_v2.example.data["username"]

  tags = {
    Name        = "Vault-bucket"
    Environment = "Dev"
  }
}
