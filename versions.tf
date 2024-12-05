terraform {
  required_version = "~> 1.5"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.2.1"
      configuration_aliases = [
        oci,
        oci.home,
        oci.frankfurt,
        oci.stockholm
      ]
    }

    # aws = {
    #   source = "hashicorp/aws"
    #   version = "~>5.3"
    # }
  }

  cloud {
    organization = "gardaworld"
    workspaces {
      name = "oracle-sesami-global"
    }
  }
}

provider "oci" {
  auth         = "APIKey"
  tenancy_ocid = var.oci_tenancy_ocid
  user_ocid    = var.oci_user_ocid
  private_key  = var.oci_private_key
  # TODO: Find a way to have that as optional.
  # For now, if keeped uncommented with a null value, it will
  # trigger an error as it will be considered an active parameter.
  # private_key_password = var.oci_private_key_password
  fingerprint = var.oci_fingerprint
  region      = var.oci_region
  alias       = "home"
}

provider "oci" {
  auth         = "APIKey"
  tenancy_ocid = var.oci_tenancy_ocid
  user_ocid    = var.oci_user_ocid
  private_key  = var.oci_private_key
  # TODO: Find a way to have that as optional.
  # For now, if keeped uncommented with a null value, it will
  # trigger an error as it will be considered an active parameter.
  # private_key_password = var.oci_private_key_password
  fingerprint = var.oci_fingerprint
  region      = var.oci_region
  alias       = "frankfurt"
}

provider "oci" {
  auth         = "APIKey"
  tenancy_ocid = var.oci_tenancy_ocid
  user_ocid    = var.oci_user_ocid
  private_key  = var.oci_private_key
  # TODO: Find a way to have that as optional.
  # For now, if keeped uncommented with a null value, it will
  # trigger an error as it will be considered an active parameter.
  # private_key_password = var.oci_private_key_password
  fingerprint = var.oci_fingerprint
  region      = var.oci_drp_region
  alias       = "stockholm"
}

# provider "aws" {
#   region = ""
#   access_key = ""
#   secret_key = ""
# }
