# sets up the dhcp server

# * DHCP range
# * Routers
# * NTP server
# * DNS server
# * Domain

class profiles::dhcpd (
  $gateway_ip,
  $netmask,
  $subnet,
  $range_start,
  $range_end,
  $dns_servers = [ $gateway_ip ],
  $routers = [ $gateway_ip ],
) {

  class { '::iscdhcpd':
    gateway_ip     => $gateway_ip,
    netmask        => $netmask,
    subnet         => $subnet,
    range_start    => $range_start,
    range_end      => $range_end,
    dns_servers    => $dns_servers,
    routers        => $routers,
  }

}
