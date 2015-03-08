class package::nodejs {

  class { '::nodejs':
  } ->
  file { '/usr/bin/node':
    ensure => link,
    target => '/usr/bin/nodejs',
  }

}