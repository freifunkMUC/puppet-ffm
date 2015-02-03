class fastd::service {
  service { 'fastd':
    ensure     => running,
    hasrestart => true,
    enable     => true,
    provider   => 'upstart',
  }

  exec { 'remove sysv startup':
    command => 'update-rc.d -f fastd remove',
    onlyif  => 'find /etc/rc* | grep "fastd"',
  }
}
