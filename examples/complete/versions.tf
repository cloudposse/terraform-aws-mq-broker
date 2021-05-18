terraform {
  required_version = ">= 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.0"
    }
  }
}
