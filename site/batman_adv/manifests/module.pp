class batman_adv::module (
  $version = '2014.3.0'
) {
  include kmod

  Exec { path => [ '/usr/local/sbin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/bin', '/bin' ] }

  case $::operatingsystem {
    'Debian': {
      if $::operatingsystemmajrelease == 'jessie/sid' {
        kmod::load { 'batman_adv':
        } ->
        package { 'batctl':
        }
      } else {
        fail("${::operatingsystemmajrelease} is not yet supported!")
      }
    }
    'Ubuntu': {
    #  package { 'batman-adv-dkms':
    #  }
    # apt-get install batman-adv-dkms
    # dkms remove batman-adv/2013.4.0 --all

    # batman-adv-dkms
    # dkms --force install batman-adv/2014.3.0
    # http://www.open-mesh.net/
    #   if $::operatingsystemmajrelease {
        kmod::load { 'batman_adv':
        } ->
        package { 'batctl':
        }
    # } else {
    #   fail("${::operatingsystemmajrelease} is not yet supported!")
    # }

      fail("${::operatingsystem} is not supported at the moment!")
    }
    default: {
      fail("${::operatingsystem} is not yet supported!")
    }
  }

}
