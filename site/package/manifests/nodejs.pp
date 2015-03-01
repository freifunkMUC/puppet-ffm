class package::nodejs {

  package { [ 'nodejs', 'npm' ]:
    ensure => present
  } ->
  file { '/usr/bin/node':
    ensure => link,
    target => '/usr/bin/nodejs',
  }

}