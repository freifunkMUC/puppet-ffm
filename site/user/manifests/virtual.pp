class user::virtual {
  include user::virtual::params

  $group = 'alfred'
  @group { $group:
    ensure => present,
  }

  $user = 'alfred'
  @user { $user:
    ensure     => present,
    gid        => $group,
    managehome => false,
    home       => '/tmp/',
    shell      => $::user::virtual::params::shell,
    require    => Group[$group],
  }

}
