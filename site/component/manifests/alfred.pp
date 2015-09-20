class component::alfred (
  $ensure        = 'present',
  $version,
  $json_version
) {
  package { 'libgps21':
    ensure  => present,
    require => Apt::Pin['libgps']
  }

  package { [ 'zlib1g', 'libjansson4']:
    ensure => $ensure
  }

  package { 'alfred':
    ensure => $version
  }

  package { 'alfred-json':
    ensure => $json_version
  }
}
