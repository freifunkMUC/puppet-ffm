class fastd::params {

  $community_folder = "/etc/fastd/${::fastd::community}-mesh-vpn"

  case $::operatingsystem {
    'Ubuntu': {
    }
    default: {
      notify { "fastd is currently not supported for ${::operatingsystem}!": }
    }
  }

}
