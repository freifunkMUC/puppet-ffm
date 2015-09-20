class fastd::params {

  case $::operatingsystem {
    'Ubuntu': {
    }
    default: {
      notify { "fastd is currently not supported for ${::operatingsystem}!": }
    }
  }

}
