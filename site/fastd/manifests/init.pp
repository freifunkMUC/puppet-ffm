# vim: set sw=2 sts=2 et tw=80 :
class fastd (
  $public_key,
  $secret_key,
  $client_pubkeys = [],
  $port = '10000',
  $server_peers = {},
  $mtu = '1426',
  $mesh_vpn_interface,
  $ciphers = [ 'salsa2012+umac', 'salsa2012+gmac', 'xsalsa20-poly1305' ],
  $community,
  $gateway_number,
  $mac_prefix,
  $mac_suffix,
) {
  include ::gwlib
  include ::fastd::service

  $hex_gateway_number  = int_to_hex( $gateway_number )
  $interface_mac = "${mac_prefix}:${hex_gateway_number}:${mac_suffix}"

  $community_folder = "/etc/fastd/${community}-mesh-vpn"

  create_resources( ::fastd::server_peer, $server_peers )

  fastd::peer { $client_pubkeys:
    community_folder => $community_folder,
  }

  package { 'fastd':
  } ->
  file { [ '/etc/fastd/', $community_folder ]:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->
  file { "$community_folder/peers/":
    ensure  => directory,
    recurse => true,
    purge   => true,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->
  file { "${community_folder}/keys.yaml":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('fastd/keys.yaml.erb'),
    notify  => Service['fastd'],
  } ->
  file { "${community_folder}/secret.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('fastd/secret.conf.erb'),
    notify  => Service['fastd'],
  } ->
  file { "${community_folder}/fastd-up":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('fastd/fastd-up.erb'),
    notify  => Service['fastd'],
  } ->
  file { "${community_folder}/fastd.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('fastd/fastd.conf.erb'),
    notify  => Service['fastd'],
  } ->
  Service['fastd']

  class { 'fastd::gluonconfig':
    fastd_port             => $port,
    fastd_public_key       => $public_key,
    fastd_community_folder => $community_folder,
  }
  File[$community_folder] -> Class['fastd::gluonconfig']

  file { '/usr/local/sbin/fastd-status':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => template('fastd/fastd-status.erb'),
  }

}
