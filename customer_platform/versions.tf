terraform {
  required_version = "~> 1.5"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.2.1"
      configuration_aliases = [
        oci,
        oci.home
      ]
    }
  }
}
