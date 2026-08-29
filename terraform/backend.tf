terraform {
  backend "s3" {
    bucket       = "terraform-shipping-lab-state-tafadzwa"
    key          = "terraform-aws-shipping-lab/lab/terraform.tfstate"
    region       = "af-south-1"
    use_lockfile = true
  }
}