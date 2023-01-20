data "vault_generic_secret" "keycloak_terraform_client_secret" {
  path = "secret/keycloak_init"
}

provider "keycloak" {
  client_id     = "terraform"
  client_secret = data.vault_generic_secret.keycloak_terraform_client_secret.data["terraform_client_secret"]
  url           = data.vault_generic_secret.keycloak_terraform_client_secret.data["keycloak_url"]
}
provider "vault" {
}
