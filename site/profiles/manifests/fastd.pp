# Installs and configures fastd

class profiles::fastd (
  $version = 'present',
) {
  package { 'fastd':
    ensure => $version,
  }
}
