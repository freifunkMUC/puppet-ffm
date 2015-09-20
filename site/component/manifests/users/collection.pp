define component::users::collection {
  # Create users from collection $name
  create_resources(
    manage_user,
    hiera_hash("component::users::${name}"),
    hiera_hash("component::users::${name}::defaults", {})
  )
}
