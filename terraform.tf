terraform {

    cloud {
        workspaces {
            name = "lambda-http-api"
        }
    
        organization = "example-org-66a440"
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>5.0"
        }
    }
}