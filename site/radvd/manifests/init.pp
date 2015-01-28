class radvd (
  $batman_bridge,
  $ipv6_prefix_without_length,
  $ipv6_prefix_length,
  $gateway_number,
) {
  include ::gwlib
  include ::radvd::service

  $hex_gateway_number = int_to_hex( $gateway_number )
  $RDNSS              = "${ipv6_prefix_without_length}${hex_gateway_number}"

  package { 'radvd':
  } ->
  file { '/etc/radvd.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('radvd/radvd.conf.erb'),
    notify  => Service['radvd'],
  } ->
  Service['radvd']

}
