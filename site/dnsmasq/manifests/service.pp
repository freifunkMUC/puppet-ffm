class dnsmasq::service (
  $enable = false,
) {
  if $enable == false {
    $ensure = 'stopped'
  } else {
    $ensure = 'running'
  }

  service { 'dns':
    ensure     => $ensure,
    name       => 'dnsmasq',
    enable     => $enable,
    hasrestart => true,
  }
}
