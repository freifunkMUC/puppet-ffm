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
  $version = 'latest',
  $purge_peers = false,
  $connection_ip = $::ipaddress_eth0,
) {
  include ::fastd::params
  include ::fastd::install
  include ::fastd::config
  include ::fastd::service
  include ::fastd::status
  include ::fastd::gluonconfig

  create_resources( ::fastd::server_peer, $server_peers )

  fastd::peer { $client_pubkeys: }

}
