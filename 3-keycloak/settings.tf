terraform {
  required_version = "v1.3.5"
  #TODO Add Backend Config here

  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.8.1"
    }
  }
}