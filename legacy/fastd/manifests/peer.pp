# vim: set sw=2 sts=2 et tw=80 :
define fastd::peer  {

  include ::fastd::params

  validate_re($name, '^.{64}$')

  file { "${::fastd::config_path}/peers/${name}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('fastd/fastd-peer.erb'),
    require => File["${::fastd::config_path}/peers/"],
    notify  => Service['fastd'],
  }

}
