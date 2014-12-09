class vpntunnel (
  $vpn_provider = 'default',
) {

  $vpn_routing_table = hiera('vpn_routing_table_nr')

# file { "/etc/openvpn/${vpn_provider}/":
#   ensure  => directory,
#   owner   => 'root',
#   group   => 'root',
#   mode    => 0755,
# } ->
# file { "/etc/openvpn/${vpn_provider}/vpn-up":
#   ensure  => file,
#   owner   => 'root',
#   group   => 'root',
#   mode    => 0744,
#   content => template('testgateway/vpn-up.erb'),
#   notify  => Service['dnsmasq'],
# }

}
