terraform {
  backend "s3" {
    bucket = "tfvishal-easy-shop-state-bucket"
    key = "terraform/terraform.tfstate"
    region = "us-east-1" # Variables not allowed
    dynamodb_table = "ES-terraform-state-lock"
    encrypt = true
  }
}