class iscdhcpd::params {

  case $::operatingsystem {
    'Ubuntu': {
      $package = 'isc-dhcp-server'
      $service_name = 'isc-dhcp-server'
    }
    default: {
      notify { "iscdhcpd is currently not supported for ${::operatingsystem}!": }
    }
  }

}
