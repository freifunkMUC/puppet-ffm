define openvpn::provider (
  $vpn_routing_table,
  $provider,
  $dependent_services = [],
  $provider_fqdns = [],
  $port = 1194,
  $username = '',
  $password = '',
  $clientcertfilename = '',
  $nativeipv4gw = '',
  $staticipv4 = '',
  $staticipv6 = '',
) {

  include ::firewall

  validate_array($dependent_services)
  validate_array($provider_fqdns)

  case $provider {
    'mullvad': {
      openvpn::mullvad { $name:
        vpn_routing_table  => $vpn_routing_table,
        dependent_services => $dependent_services,
        provider_fqdns     => $provider_fqdns,
        port               => $port,
      }
    }
    'ipredator': {
      openvpn::ipredator { $name:
        vpn_routing_table  => $vpn_routing_table,
        dependent_services => $dependent_services,
        username           => $username,
        password           => $password,
      }
    }
    'ipredatorstatic': {
      $ipv6 = split($staticipv6,'/')
      $ipv6_prefix = $ipv6[0]
      $ipv6_mask = $ipv6[1]
      openvpn::ipredatorstatic { $name:
        vpn_routing_table  => $vpn_routing_table,
        dependent_services => $dependent_services,
        clientcertfilename => $clientcertfilename,
	nativeipv4gw       => $nativeipv4gw,
	staticipv4         => $staticipv4,
        staticipv6         => $staticipv6,
	staticipv6prefix   => $ipv6_prefix,
        staticipv6mask     => $ipv6_mask,
      }
    }
    default: {
      fail("provider ${provider} is not yet supported.")
    }
  }

  firewall { "001 ${name} Masquerade VPN Traffic":
    provider => 'iptables',
    chain    => 'POSTROUTING',
    table    => 'nat',
    outiface => "${name}",   # prevents "can't modify frozen String"
    proto    => 'all',
    jump     => 'MASQUERADE',
  }

}
