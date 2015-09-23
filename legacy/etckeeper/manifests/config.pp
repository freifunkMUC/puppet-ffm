class etckeeper::config {

  file { '/etc/etckeeper/etckeeper.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['etckeeper'],
    source  => 'puppet:///modules/etckeeper/etckeeper.conf',
  }

}
