class component::dnsmasq (
  $pools = {},
  $dnsservers = {},
) {
  class { '::dnsmasq':
    config_hash => hiera_hash('dnsmasq::config_hash', {}),
  }

  contain ::dnsmasq

  create_resources('dnsmasq::dhcp', $pools)
  create_resources('dnsmasq::dnsserver', $dnsservers)
}
