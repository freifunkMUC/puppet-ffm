class dnsmasq::service (
  $manage_service = false,
) {

  if $manage_service == true {
    $ensure = 'running'
    $enable = true

    service { 'dns':
      ensure     => $ensure,
      name       => 'dnsmasq',
      enable     => $enable,
      hasrestart => true,
    }
  }
}
