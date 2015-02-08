define openvpn::provider (
  $vpn_routing_table,
  $dependent_services,
  $provider_fqdns,
  $port,
  $provider,
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
