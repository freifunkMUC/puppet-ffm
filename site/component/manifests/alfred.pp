class component::alfred (
  $ensure  = 'present',
  $version = '2014.4*',
) {
  package { 'libgps21':
    ensure  => present,
    require => Apt::Pin['libgps']
  }

  package { [ 'zlib1g', 'libjansson4', 'alfred-json']:
    ensure => $ensure
  }

  package { 'alfred':
    ensure => $version
  }
}
