# vim: set sw=2 sts=2 et tw=80 :
define fastd::server_peer (
  $public_key,
  $fastd_port,
  $contact,
) {

  include ::fastd::params

  if ($name != $::fqdn) and ($name != $::fastd::connection_ip) {
    file {"${::fastd::params::community_folder}/peers/${name}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('fastd/fastd-server-peer.erb'),
      require => [ Package['fastd'], File["${::fastd::params::community_folder}/peers/"] ],
      notify  => Service['fastd'],
    }
  }
}

