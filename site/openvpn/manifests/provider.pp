define openvpn::provider (
  $vpn_routing_table,
  $dependent_services,
  $provider_fqdns = [],
  $port = 1194,
  $provider,
  $username,
  $password
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
	username => $username,
	password => $password,
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
