terraform {
  backend "s3" {
    bucket = "dvops-01"
    key    = "oberservability/terraform.tfstate"
    region = "us-east-1"
  }
}