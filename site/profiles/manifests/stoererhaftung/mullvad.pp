class profiles::stoererhaftung::mullvad (
  $vpn_interface,
  $vpn_routing_table,
  $dns_service,
) {

  class { '::openvpn':
    notify_exec => "stop ${dns_service}",
  }
  contain ::openvpn

  # this is needed because openvpn cannot connect unless it has
  # already dns. since our ${dns_service} will tunnel requests
  # through mullvad, we need to stop it.
  exec { "stop ${dns_service}":
    command     => "service ${dns_service} stop",
    refreshonly => true,
    onlyif      => "service ${dns_service} status",
  }

  $mullvad_path = '/etc/openvpn/mullvad'

  file { '/etc/openvpn/':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->
  file { '/etc/openvpn/mullvad.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profiles/mullvad.conf.erb'),
    notify  => Service['openvpn'],
  } ->
  file { $mullvad_path:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->
  file { "${mullvad_path}/mullvad-up":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0754',
    content => template('profiles/mullvad-up.erb'),
    notify  => Service['openvpn'],
  } ->
  file { "${mullvad_path}/mullvad-down":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0754',
    content => template('profiles/mullvad-down.erb'),
    notify  => Service['openvpn'],
  }

  package { 'unzip':
    ensure => installed,
  } ->
  file { '/tmp/mullvad':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  } ->
  file { '/tmp/mullvad/mullvadconfig.zip':
    ensure => file,
    source => 'puppet:///modules/profiles/mullvad/mullvadconfig.zip',
    notify => Exec['unzip mullvadconfig'],
  }

  exec { 'unzip mullvadconfig':
    command     => 'unzip -u /tmp/mullvad/mullvadconfig.zip -d /tmp/mullvad/',
    refreshonly => true,
    notify      => Exec["move openvpn-config-files to ${mullvad_path}"],
  }

  exec { "move openvpn-config-files to ${mullvad_path}":
    command     => "mv [0-9]*/ca.crt [0-9]*/crl.pem [0-9]*/mullvad.crt [0-9]*/mullvad.key ${mullvad_path}",
    cwd         => '/tmp/mullvad/',
    refreshonly => true,
    require     => File[$mullvad_path],
  } ->
  file { [ "${mullvad_path}/ca.crt", "${mullvad_path}/ca.pem", "${mullvad_path}/mullvad.crt", "${mullvad_path}/mullvad.key"]:
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    notify => Service['openvpn'],
  } ->
  Service['openvpn']

  exec { "check for ${vpn_interface}":
    command => "true",
    unless  => "ifconfig | grep ${vpn_interface}",
    notify  => Service['openvpn'],
  }

}
