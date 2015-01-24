class profiles::stoererhaftung::mullvad (
  $vpn_interface,
  $vpn_routing_table_nr,
  $dns_service,
) {

  require openvpn

  file { '/etc/openvpn/mullvad.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profiles/mullvad.conf.erb'),
    notify  => Service['openvpn'],
  } ->
  file { '/etc/openvpn/mullvad':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->
  file { '/etc/openvpn/mullvad/mullvad-up':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0754',
    content => template('profiles/mullvad-up.erb'), 
    notify  => Service['openvpn'],
  }

}
