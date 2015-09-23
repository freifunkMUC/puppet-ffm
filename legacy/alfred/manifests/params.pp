class alfred::params {
  case $::operatingsystem {
    'Ubuntu': {
      $libgps21_ensure = '3.11*'
    }
    default: {
      warning("alfred is currently not supported for ${::operatingsystem}!")
    }
  }

  case $::architecture {
    'x86_64', 'amd64': {
      $arch = 'amd64'
    }
    default: {
      warning("alfred is currently not supported for ${::architecture}!")
    }
  }
}
