resource "keycloak_group" "developer" {
  realm_id = data.keycloak_realm.gotc.id
  name     = "DEVELOPER"
}

resource "keycloak_group_memberships" "developer_group_members" {
  realm_id = data.keycloak_realm.gotc.id
  group_id = keycloak_group.developer.id

  members  = [
    keycloak_user.sophia_smith.username
  ]
}