class etckeeper::setup {
  exec { '/usr/bin/etckeeper init':
    creates => '/etc/.etckeeper',
    require => File['/etc/etckeeper/etckeeper.conf'],
  }
}
