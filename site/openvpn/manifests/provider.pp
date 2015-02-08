define openvpn::provider (
  $vpn_routing_table,
  $dependent_services,
  $provider_fqdn,
  $port,
  $provider,
) {

  include ::firewall

  case $provider {
    mullvad: {
      openvpn::mullvad { $name:
        vpn_routing_table  => $vpn_routing_table,
        dependent_services => $dependent_services,
        provider_fqdn      => $provider_fqdn,
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