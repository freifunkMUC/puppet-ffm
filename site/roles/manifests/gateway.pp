# Installs and configures all services necessary
# for a freifunk gateway

class roles::gateway {
  include profiles::apt
  include profiles::etckeeper
  include gluonconfig

  $mesh_vpn_interface   = hiera('mesh_vpn_interface')
  $gateway_number       = hiera('gateway_number')
  $community            = hiera('community')
  $vpn_routing_table_nr = hiera('vpn_routing_table_nr')
  $batman_bridge        = hiera('batman_bridge')
  $vpn_service          = hiera('vpn_service', 'undefined')
  $no_vpn_interface     = hiera('no_vpn_interface', undef)

  class { 'profiles::dhcpd':
    gateway_number => $gateway_number,
  }

  class { 'profiles::networking':
    batman_bridge        => $batman_bridge,
    mesh_vpn_interface   => $mesh_vpn_interface,
    gateway_number       => $gateway_number,
    vpn_routing_table_nr => $vpn_routing_table_nr,
  } ->
  class { 'profiles::alfred':
  }

  class { 'profiles::fastd':
    mesh_vpn_interface => $mesh_vpn_interface,
    community          => $community,
    gateway_number     => $gateway_number,
  }


  if $vpn_service != 'undefined' {
    $traffic_interface = $vpn_service
  } elsif $no_vpn_interface != undef {
    $traffic_interface = $no_vpn_interface
  } else {
    fail('vpn_interface could not be derived from vpn_service. Also there was no alternative provided.')
  }

  class { '::profiles::firewall':
    vpn_interface => $traffic_interface,
    batman_bridge => $batman_bridge,
  }

  class { "::profiles::stoererhaftung::${vpn_service}":
    vpn_interface        => $traffic_interface,
    vpn_routing_table_nr => $vpn_routing_table_nr,
    dns_service          => 'dnsmasq',
  } ->
  class { '::profiles::dns':
    no_dhcp_interface => $batman_bridge,
    forward_interface => $traffic_interface,
  }

}

