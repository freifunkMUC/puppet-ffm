# Installs and configures all services necessary
# for a freifunk gateway

class roles::gateway {
  include profiles::apt
  include profiles::etckeeper
  include profiles::monitoring
  include gluonconfig
  include user::virtual

  $mesh_vpn_interface     = hiera('mesh_vpn_interface')
  $gateway_number         = hiera('gateway_number')
  $gateway_ip             = hiera('gateway_ip')
  $netmask                = hiera('netmask')
  $subnet                 = hiera('subnet')
  $community              = hiera('community')
  $vpn_routing_table_nr   = hiera('vpn_routing_table_nr')
  $vpn_routing_table_name = hiera('vpn_routing_table_name')
  $batman_bridge          = hiera('batman_bridge')
  $vpn_service            = hiera('vpn_service', 'undefined')
  $no_vpn_interface       = hiera('no_vpn_interface', undef)
  $dns_service            = 'dnsmasq'

  class { 'profiles::networking':
    batman_bridge          => $batman_bridge,
    mesh_vpn_interface     => $mesh_vpn_interface,
    gateway_number         => $gateway_number,
    gateway_ip             => $gateway_ip,
    netmask                => $netmask,
    vpn_routing_table_nr   => $vpn_routing_table_nr,
    vpn_routing_table_name => $vpn_routing_table_name,
  } ->
  class { 'profiles::alfred':
  } ->
  class { 'profiles::fastd':
    mesh_vpn_interface => $mesh_vpn_interface,
    community          => $community,
    gateway_number     => $gateway_number,
  }

  Class['batman_adv'] ->
  class { 'profiles::dhcpd':
    gateway_ip => $gateway_ip,
    netmask    => $netmask,
    subnet     => $subnet,
    interface  => $batman_bridge,
  }

  if $vpn_service != 'undefined' {
    $traffic_interface = $vpn_service

    # our dnsmasq should be stopped and not startet on reboot by puppet beause
    # the vpn_service-up script for openvpn will start it when the tunnel is ready
    $manage_dns_service = false
  } elsif $no_vpn_interface != undef {
    $traffic_interface = $no_vpn_interface

    $manage_dns_service = true
  } else {
    fail('vpn_interface could not be derived from vpn_service. Also there was no alternative with no_vpn_interface provided.')
  }

  class { '::profiles::firewall':
    vpn_interface => $traffic_interface,
    batman_bridge => $batman_bridge,
  }

  class { '::profiles::dns':
    dns_service       => $dns_service,
    no_dhcp_interface => $batman_bridge,
    forward_interface => $traffic_interface,
    manage_service    => $manage_dns_service,
  }

  class { "::profiles::stoererhaftung::${vpn_service}":
    vpn_interface     => $traffic_interface,
    vpn_routing_table => $vpn_routing_table_name,
    dns_service       => $dns_service,
  }

  Service['dns'] -> Service['openvpn']

}
