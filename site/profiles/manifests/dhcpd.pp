# sets up the dhcp server

# * DHCP range
# * Routers
# * NTP server
# * DNS server
# * Domain

class profiles::dhcpd (
  $gateway_number,
) {

  class { '::iscdhcpd':
    gateway_number => $gateway_number,
  }

}
