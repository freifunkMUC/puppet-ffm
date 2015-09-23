# sets up the dhcp server

# * DHCP range
# * Routers
# * NTP server
# * DNS server
# * Domain

class profile::dhcpd (
  $subnet,
  $range_start,
  $range_end,
  $dns_servers = [ $profile::batman_adv::gateway_ip ],
  $routers = [ $profile::batman_adv::gateway_ip ],
) {

  include ::profile::batman_adv

  class { '::iscdhcpd':
    gateway_ip  => $::profile::batman_adv::gateway_ip,
    netmask     => $::profile::batman_adv::netmask,
    subnet      => $subnet,
    range_start => $range_start,
    range_end   => $range_end,
    dns_servers => $dns_servers,
    routers     => $routers,
    interface   => $::profile::batman_adv::bridge,
  }

}
