# vim: set sw=2 sts=2 et tw=80 :
define fastd::server_peer (
  $public_key,
  $fastd_port,
  $contact,
) {

  $community = hiera('community')
  $community_folder = "/etc/fastd/${community}-mesh-vpn"

  $fastd_connection_ip = hiera('fastd::fastd_connection_ip')
  if ($name != $::fqdn) and ($name != $fastd_connection_ip) {
    file {"${community_folder}/peers/${name}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('fastd/fastd-server-peer.erb'),
      require => [ Server['fastd'], File["${community_folder}/peers/"] ],
      notify  => Service['fastd'],
    }
  }
}

