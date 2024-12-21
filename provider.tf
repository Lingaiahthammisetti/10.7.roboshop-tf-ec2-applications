terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.66.0"
    }
  }

  backend "s3" {
    bucket = "roboshop-remote-state-dev-ec2"
    key    = "roboshop-project"
    region = "us-east-1"
    dynamodb_table = "roboshop-locking-dev-ec2"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}