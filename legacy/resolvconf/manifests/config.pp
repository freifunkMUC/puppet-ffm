class resolvconf::config {

  file { '/etc/resolvconf/resolv.conf.d/tail':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('resolvconf/tail.erb'),
    notify  => Exec['update resolvconf'],
    require => Package['resolvconf'],
  }

  exec { 'update resolvconf':
    command     => 'resolvconf -u',
    refreshonly => true,
  }

}
