locals {
  test_user_firstname = "sophia"
  test_user_lastname  = "smith"
}

data "keycloak_realm" "gotc" {
  realm = "gotc"
}

resource "keycloak_user" "sophia_smith" {
  realm_id = data.keycloak_realm.gotc.id
  username = "${local.test_user_firstname}.${local.test_user_lastname}"
  enabled  = true

  email      = "${local.test_user_firstname}.${local.test_user_lastname}@domain.com"
  first_name = local.test_user_firstname
  last_name  = local.test_user_lastname


  initial_password {
    value     = var.sophia_smith_password
    temporary = false
  }
}