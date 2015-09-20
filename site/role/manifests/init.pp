class role (
  $role_prefix      = 'role',
  $role_class       = undef,
  $default_profiles = []
) {
  validate_re($role_class, "^(?!.*${role_prefix}::)", "role_class must not include role_prefix (${role_prefix}): ${role_class}")

  if $role_class != 'undef' {
    contain "${role_prefix}::${role_class}"
  } else {
    fail('No role specified!')
  }

  each($default_profiles) |$profile| {
    contain "::profile::${profile}"
  }
}
