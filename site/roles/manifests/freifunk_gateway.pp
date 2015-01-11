# Installs and configures all services necessary
# for a freifunk gateway (ffm config)

class roles::freifunk_gateway {
  include profiles::etckeeper

  $fastd_connection_interface = hiera('fastd_connection_interface')
  $mesh_vpn_interface         = hiera('mesh_vpn_interface')
  $gateway_number             = hiera('gateway_number')
  $community                  = hiera('community')
  $vpn_routing_table_nr       = hiera('vpn_routing_table_nr')

  class { 'profiles::firewall':
    fastd_connection_interface => $fastd_connection_interface,
  }

  class { 'profiles::dhcpd':
    gateway_number => $gateway_number,
  }

  class { 'profiles::networking':
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

  include profiles::apt
  include profiles::dhcpd
  include profiles::dns
  include gluonconfig

  include profiles::alfred
}

