class dnsmasq::service  {

  if $::dnsmasq::manage_service == true {
    $enable = true
  } else {
    $enable = false
  }

  service { 'dns':
    ensure     => 'running',
    name       => 'dnsmasq',
    enable     => $enable,
    hasrestart => true,
  }
}
