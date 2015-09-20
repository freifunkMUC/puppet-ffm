class profile::default (
  $default_components = [],
  $default_packages   = []
) {
  each($default_components) |$component| {
    contain "::component::${component}"
  }
}
