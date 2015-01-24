class profiles::dns (
  $no_dhcp_interface,
  $forward_interface,
) {

  $dns_interfaces = [ $no_dhcp_interface ]

  class { 'dnsmasq':
    dns_interfaces    => $dns_interfaces,
    no_dhcp_interface => $no_dhcp_interface,
    forward_interface => $forward_interface,
  }

}

