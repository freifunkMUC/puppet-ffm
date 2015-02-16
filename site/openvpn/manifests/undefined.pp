class openvpn::undefined (
  $interface,
  $routing_table,
  $default_gateway_ip,
) {

  validate_ipv4_address($default_gateway_ip)

  warning('You have not defined openvpn::configs in any yaml-file within the hieradata folder! The node-traffic will exit right at your gateway into the internet!')

  exec { "ip route flush table ${routing_table}":
    unless => "ip route show table ${routing_table} | grep ${interface}",
    notify => Exec['ip route add default openvpn::undefined'],
  }

  exec { 'ip route add default openvpn::undefined':
    command     => "ip route add default via ${default_gateway_ip} dev ${interface} table ${routing_table}",
    refreshonly => true,
  }

  include ::firewall

  firewall { '001 Masquerade VPN Traffic':
    provider => 'iptables',
    chain    => 'POSTROUTING',
    table    => 'nat',
    outiface => $interface,
    proto    => 'all',
    jump     => 'MASQUERADE',
  }

}
