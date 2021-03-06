class component::batman (
  $ensure = 'present',
) {
  include ::kmod

  kmod::load { 'batman_adv': }

  package { 'batctl':
    ensure => $ensure,
  }

  case $::operatingsystem {
    'Ubuntu': {
      case $::lsbdistcodename {
        'trusty': {
          package { 'linux-image-generic-lts-vivid':
            ensure => $ensure,
          }
        }
        default: {
          fail("${::operatingsystem} ${::lsbdistcodename} not yet supported!")
        }
      }
    }
    'Debian': {
      package { 'linux-image-amd64':
        ensure => '4.*',
      }
    }
    default: {
      fail("${::operatingsystem} yet supported!")
    }
  }

}
