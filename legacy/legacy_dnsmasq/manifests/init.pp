# vim: set sw=2 sts=2 et tw=80 :
class dnsmasq (
  $dns_interfaces,
  $no_dhcp_interface,
  $forward_interfaces = [],
  $upstream_servers = [ '85.214.20.141', '213.73.91.35' ],
  $listen_address = '127.0.0.1',
  $ensure = 'installed',
) {

  include ::dnsmasq::install
  include ::dnsmasq::config
  include ::dnsmasq::service

  validate_ipv4_address($listen_address)

}
