terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.67.0"
    }
  }

  backend "kubernetes" {
    secret_suffix    = "okteto"
  }
  
  required_version = ">= 1.2.0"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  default     = ""
  validation {
    condition     = length(var.cloudflare_api_token) > 1
    error_message = "Please specify the Cloudflare API token"
  }
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  default     = ""
  validation {
    condition     = length(var.cloudflare_zone_id) > 1
    error_message = "Please specify the Cloudflare Zone ID"
  }
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
  default     = ""
  validation {
    condition     = length(var.cloudflare_account_id) > 1
    error_message = "Please specify the Cloudflare account ID"
  }
}

variable "cloudflare_record_name" {
  description = "Cloudflare Record Name"
  type        = string
  default     = ""
  validation {
    condition     = length(var.cloudflare_record_name) > 1
    error_message = "Please specify the Cloudflare Record Name"
  }
}

variable "cloudflare_record_value" {
  description = "Cloudflare Record Value"
  type        = string
  default     = ""
  validation {
    condition     = length(var.cloudflare_record_value) > 1
    error_message = "Please specify the Record Value"
  }
}

variable "cloudflare_bucket_name" {
  description = "Name of the R2 Bucket"
  type        = string
  default     = ""
  validation {
    condition     = length(var.cloudflare_bucket_name) > 1
    error_message = "Please specify the name of the S3 bucket"
  }
}

variable "sqs_queue_name" {
  description = "SQS Queue name"
  type        = string
  default     = ""
  validation {
    condition     = length(var.sqs_queue_name) > 1
    error_message = "Please specify the SQS Queue name"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "aws" {
  region  = "us-west-2"
}

resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = var.cloudflare_record_name
  value   = "127.0.0.1"
  type    = "A"
  proxied = true
  allow_overwrite = true
}

resource "cloudflare_ruleset" "www" {
  zone_id = var.cloudflare_zone_id
  name = var.cloudflare_record_name
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"
  rules {
    action = "redirect"
    action_parameters {
      from_value {
        status_code = 301
        target_url {
          value = var.cloudflare_record_value
        }
        preserve_query_string = false
      }
    }
    expression  = "(http.host eq \"${var.cloudflare_record_name}\")"
    description = "Redirect visitors still using old URL"
    enabled     = true
  }
}


resource "cloudflare_r2_bucket" "checks_bucket" {
  account_id = var.cloudflare_account_id
  name       = var.cloudflare_bucket_name
  location   = "WNAM"
}

resource "aws_sqs_queue" "orders_queue"  {
    name = var.sqs_queue_name       
}

output "queue_url" {
  value = aws_sqs_queue.orders_queue.url
  description = "The URL of the SQS queue"
}