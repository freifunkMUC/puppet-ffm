class profiles::dns (
  $no_dhcp_interface,
  $forward_interface,
  $dns_service,
  $enable,
) {

  $dns_interfaces = [ $no_dhcp_interface ]

  class { "::${dns_service}":
    dns_interfaces    => $dns_interfaces,
    no_dhcp_interface => $no_dhcp_interface,
    forward_interface => $forward_interface,
    enable            => $enable,
  }
  contain "::${dns_service}"

}

