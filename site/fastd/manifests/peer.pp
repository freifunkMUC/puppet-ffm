# vim: set sw=2 sts=2 et tw=80 :
define fastd::peer  {

  include ::fastd::params

  file { "${::fastd::params::community_folder}/peers/${name}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('fastd/fastd-peer.erb'),
    require => File["${::fastd::params::community_folder}/peers/"],
    notify  => Service['fastd'],
  }

}
