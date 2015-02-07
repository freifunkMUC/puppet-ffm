class dnsmasq::service  {

  service { 'dns':
    ensure     => 'running',
    name       => 'dnsmasq',
    enable     => true,
    hasrestart => true,
  }

  # to prevent resolving-issues
  Package <||> -> Service['dns']

}
