class profiles::firewall (
  $purge = false,
  $route_traffic_through_vpn_tunnel = true,
  $fastd_connection_interface,
) {

  if str2bool($purge) {
    resources { 'firewall':
      purge => true,
    }
  }

  class { '::firewall': }

  $batman_bridge = hiera('batman_bridge')

  if $route_traffic_through_vpn_tunnel {
    firewall { '100 Mark Mesh VPN Traffic':
      provider => 'iptables',
      chain    => 'PREROUTING',
      table    => 'mangle',
      iniface  => $batman_bridge,
      proto    => 'all',
      jump     => 'MARK',
      set_mark => '0x1/0xffffffff',
    }
  }

  firewall { '001 Masquerade VPN Traffic':
    provider => 'iptables',
    chain    => 'POSTROUTING',
    table    => 'nat',
    outiface => $fastd_connection_interface,
    proto    => 'all',
    jump     => 'MASQUERADE',
  }

}
