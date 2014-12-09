class profiles::dns {

  $no_dhcp_interface = hiera('batman_bridge')
  $dns_interfaces    = [ $no_dhcp_interface ]

  class { 'dnsmasq':
    dns_interfaces    => $dns_interfaces,
    no_dhcp_interface => $no_dhcp_interface,
  }

}

