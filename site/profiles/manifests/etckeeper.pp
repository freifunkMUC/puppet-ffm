class profiles::etckeeper {

  include ::apt

  package { 'git': } ->
  package { 'etckeeper': } ->

  file { '/etc/etckeeper/etckeeper.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/profiles/etckeeper.conf',
  } ->

  exec { '/usr/bin/etckeeper init':
    creates => '/etc/.etckeeper',
  }
}
