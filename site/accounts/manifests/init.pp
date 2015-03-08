class accounts (
  $users  = {},
  $groups = hash([]),
  $ssh_authorized_keys = {},
) {
  create_resources(user, $users)
  create_resources(group, $groups)
  create_resources(ssh_authorized_key, $ssh_authorized_keys)
}
