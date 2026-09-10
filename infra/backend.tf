terraform {
  backend "s3" {
    bucket = "dvops-01"
    key    = "3tier_infra/terraform.tfstate"
    region = "us-east-1"
  }
}