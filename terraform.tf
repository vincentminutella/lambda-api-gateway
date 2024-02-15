terraform {

    cloud {
        workspaces {
            name = "lambda-http-api"
        }
    
        organization = "brosona"
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>5.0"
        }
    }
}