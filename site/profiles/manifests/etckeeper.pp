class profiles::etckeeper {

  include ::apt
  Exec['apt_update'] -> Package <| title != 'etckeeper' and title != 'git' |>

  package { 'git':
  } ->
  package { 'etckeeper':
  } -> File <| |>

  file { '/etc/etckeeper/etckeeper.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/profiles/etckeeper.conf',
  } ->
  exec { 'etckeeper init':
    path   => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin/:/usr/sbin/:/sbin',
  }
}
