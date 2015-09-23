define component::users::managed (
  $password='!',
  $comment='',
  $ensure='present',
  $groups=[],
  $home=undef,
  $ssh_authorized_keys={}
) {
  user { $name:
    ensure     => $ensure,
    password   => $password,
    managehome => true,
    shell      => '/bin/bash',
    groups     => $groups,
    comment    => $comment,
    home       => $home,
  }

  $ssh_dir = $home ? {
    undef   => "/home/${name}/.ssh",
    default => "${home}/.ssh"
  }

  file { $ssh_dir:
    ensure  => directory,
    mode    => '0700',
    owner   => $name,
    require => User[$name],
  }

  create_resources('Ssh_authorized_key', $ssh_authorized_keys, {
    user    => $name,
    require => File[$ssh_dir],
  })
}

