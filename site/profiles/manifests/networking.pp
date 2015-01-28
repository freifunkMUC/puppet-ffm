class profiles::networking (
  $batman_bridge,
  $gateway_number,
  $gateway_ip,
  $netmask,
  $mesh_vpn_interface,
  $vpn_routing_table_nr,
  $vpn_routing_table_name,
  $ipv6_prefix_without_length,
  $ipv6_prefix_length,
) {

  class { 'batman_adv':
    bridge                     => $batman_bridge,
    mesh_vpn_interface         => $mesh_vpn_interface,
    gateway_number             => $gateway_number,
    gateway_ip                 => $gateway_ip,
    netmask                    => $netmask,
    vpn_routing_table          => $vpn_routing_table_name,
    ipv6_prefix_without_length => $ipv6_prefix_without_length,
  } ->
  class { 'radvd':
    batman_bridge              => $batman_bridge,
    gateway_number             => $gateway_number,
    ipv6_prefix_without_length => $ipv6_prefix_without_length,
    ipv6_prefix_length         => $ipv6_prefix_length,
  }

  sysctl {
    'net.ipv4.ip_forward': value => '1',
  }

  sysctl {
    'net.ipv6.conf.all.forwarding': value => '1',
  }

  sysctl {
    'net.ipv4.conf.default.rp_filter': value => '2',
  }

  sysctl {
    'net.ipv4.conf.all.rp_filter': value => '2',
  }

  augeas { 'routing table':
    context => '/files/etc/iproute2/rt_tables',
    changes => "set ${vpn_routing_table_name} ${vpn_routing_table_nr}",
    onlyif  => "match ${vpn_routing_table_name}[. = '${vpn_routing_table_nr}'] size == 0",
    incl    => '/etc/iproute2/rt_tables',
    lens    => 'IPRoute2.lns',
  }

}
