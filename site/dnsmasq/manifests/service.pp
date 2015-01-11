class dnsmasq::service {
  service { 'dns':
    ensure     => running,
    name       => 'dnsmasq',
    hasrestart => true,
  }
}
