data "opentelekomcloud_identity_project_v3" "current" {}

resource "opentelekomcloud_identity_user_v3" "sophia_smith" {
  name     = "sophia_smith"
  password = var.sophia_smith_password
  enabled = true
  default_project_id = data.opentelekomcloud_identity_project_v3.current.id
}

resource "opentelekomcloud_identity_group_v3" "authdemo_cce_viewer" {
  name        = "authdemo_cce_viewer"
  description = "CCE Viewer group for the project authdemo"
}

resource "opentelekomcloud_identity_role_v3" "authdemo_cce_viewer" {
  description   = "CCE Viewer role for the project authdemo"
  display_name  = "authdemo_cce_viewer"
  display_layer = "project"
  statement {
    effect = "Allow"
    action = [
      "cce:*:get",
      "cce:*:list",
      "ecs:*:get*",
      "ecs:*:list*",
      "evs:*:get*",
      "evs:*:list",
      "evs:*:count",
      "vpc:*:get",
      "vpc:*:list",
      "sfs:*:get*",
      "sfs:shares:ShareAction",
      "aom:*:get",
      "aom:*:list",
      "aom:autoScalingRule:*"
    ]
  }
}

resource "opentelekomcloud_identity_role_assignment_v3" "authdemo_cce_viewer" {
  group_id   = opentelekomcloud_identity_group_v3.authdemo_cce_viewer.id
  project_id = data.opentelekomcloud_identity_project_v3.current.id
  role_id    = opentelekomcloud_identity_role_v3.authdemo_cce_viewer.id
}

resource "opentelekomcloud_identity_user_group_membership_v3" "sophia_smith_developer" {
  user = opentelekomcloud_identity_user_v3.sophia_smith.id
  groups = [
    opentelekomcloud_identity_group_v3.authdemo_cce_viewer.id,
  ]
}

output "authdemo_cce_viewer_group_id" {
  value = opentelekomcloud_identity_group_v3.authdemo_cce_viewer.id
}