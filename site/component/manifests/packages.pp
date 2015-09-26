class component::packages (
  $names=[],
) {
  $merged_names = unique(concat(hiera_array('component::packages::names'), $names))

  package { $merged_names:
    ensure => installed,
  }
}
