class component::dnsmasq (
  $pools = {}
) {
  contain ::dnsmasq

  create_resources('dnsmasq::dhcp', $pools)
}
