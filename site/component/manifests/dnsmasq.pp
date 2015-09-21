class component::dnsmasq (
  $pools = {},
  $dnsservers = {}
) {
  contain ::dnsmasq

  create_resources('dnsmasq::dhcp', $pools)
  create_resources('dnsmasq::dnsserver', $dnsservers)
}
