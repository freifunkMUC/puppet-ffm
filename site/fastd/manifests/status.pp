class fastd::status {

  file { '/usr/local/sbin/fastd-status':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => template('fastd/fastd-status.erb'),
  }

}
