# vim: set sw=2 sts=2 et tw=80 :
class fastd (
  $public_key,
  $secret_key,
  $mesh_vpn_interface,
  $gateway_number,
  $mac_prefix,
  $mac_suffix,
  $config_path,
  $ciphers = [ 'salsa2012+umac', 'salsa2012+gmac', 'xsalsa20-poly1305' ],
  $client_pubkeys = [],
  $server_peers = {},
  $port = '10000',
  $mtu = '1426',
  $version = 'latest',
  $purge_peers = false,
  $connection_ip = $::ipaddress,
  $routing_type = 'batman',
  $routing_interface = 'bat0',
  $log_level = 'warn',
  $on_verify_command = 'undefined',
) {
  include ::fastd::params
  include ::fastd::install
  include ::fastd::config
  include ::fastd::service
  include ::fastd::status
  include ::fastd::gluonconfig

  validate_re($public_key, '^.{64}$', 'public_key is not 64 characters long!')
  validate_re($secret_key, '^.{64}$', 'secret_key is not 64 characters long!')
  validate_bool($purge_peers)

  if ! is_integer($mtu) {
    fail('mtu is not an integer!')
  } elsif $mtu < 0 or $mtu > 2000 {
    fail('make sure that your mtu is valid!')
  }

  if ! is_integer($gateway_number) {
    fail('gateway_number is not an integer!')
  } elsif $gateway_number < 0 {
    fail('gateway_number is not a positive integer!')
  }

  if ! is_integer($port) {
    fail("port '${port}' is not an integer!")
  } elsif ! ($port > 1024) or ! ($port < 65536) {
    fail("port '${port}' is not a valid port-number!")
  }

  $log_level_array = ['error', 'warn', 'info', 'verbose', 'debug', 'debug2']
  if !($log_level in $log_level_array) {
    fail("${log_level} is not a valid log-level for fastd!")
  }

  create_resources( ::fastd::server_peer, $server_peers )

  fastd::peer { $client_pubkeys: }

}
