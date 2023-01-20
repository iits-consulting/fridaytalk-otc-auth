locals {
  test_user_firstname = "sophia"
  test_user_lastname  = "mustermann"

}

data "keycloak_realm" "gotc" {
  realm = "gotc"
}


resource "random_password" "sophia_mustermann_password" {
  length      = 32
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

resource "keycloak_user" "sophia_mustermann" {
  realm_id = data.keycloak_realm.gotc.id
  username = "${local.test_user_firstname}.${local.test_user_lastname}"
  enabled  = true

  email      = "${local.test_user_firstname}.${local.test_user_lastname}@domain.com"
  first_name = local.test_user_firstname
  last_name  = local.test_user_lastname


  initial_password {
    value     = random_password.sophia_mustermann_password.result
    temporary = false
  }
}