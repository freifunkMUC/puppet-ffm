class component::network (
) {
  package { 'bridge-utils':
    ensure => present,
    before => Class['::network'],
  }
}
