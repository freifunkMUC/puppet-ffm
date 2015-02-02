class user::virtual::params {

  case $::operatingsystem {
    'Ubuntu': {
      $nologin = '/usr/sbin/nologin'
      $shell = '/bin/bash'
    }
    default: {
      notify { "user::virtual is currently not supported for ${::operatingsystem}!": }
    }
  }

}
