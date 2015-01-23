# Installs and configures all services necessary
# for a freifunk gateway

class roles::gateway {
  include profiles::apt
  include profiles::etckeeper

  $fastd_connection_interface = hiera('fastd_connection_interface')
  $mesh_vpn_interface         = hiera('mesh_vpn_interface')
  $gateway_number             = hiera('gateway_number')
  $community                  = hiera('community')
  $vpn_routing_table_nr       = hiera('vpn_routing_table_nr')
  $batman_bridge              = hiera('batman_bridge')
  $vpn_interface              = hiera('vpn_interface')

  class { 'profiles::firewall':
    vpn_interface => $vpn_interface,
    batman_bridge => $batman_bridge,
  }

  class { 'profiles::dhcpd':
    gateway_number => $gateway_number,
  }

  class { 'profiles::networking':
    batman_bridge              => $batman_bridge,
    fastd_connection_interface => $fastd_connection_interface,
    mesh_vpn_interface         => $mesh_vpn_interface,
    gateway_number             => $gateway_number,
    vpn_routing_table_nr       => $vpn_routing_table_nr,
  }

  class { 'profiles::fastd':
    mesh_vpn_interface => $mesh_vpn_interface,
    community          => $community,
    gateway_number     => $gateway_number,
  }

  class { 'profiles::dns':
    no_dhcp_interface => $batman_bridge,
    vpn_interface     => $vpn_interface,
  }

  include gluonconfig
  include profiles::alfred
}

