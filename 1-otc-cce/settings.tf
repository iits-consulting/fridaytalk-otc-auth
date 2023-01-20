terraform {
  required_version = "v1.3.5"
  #TODO Add Backend Config here

  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.32.2"
    }
  }
}