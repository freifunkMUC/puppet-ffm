define openvpn::mullvad (
  $vpn_routing_table,
  $dependent_services,
  $provider_fqdns,
  $port,
) {
  include ::openvpn
  include ::package::unzip

  if count($provider_fqdns) == 0 {
    fail('provider_fqdns needs to contain at least one valid fqdn!')
  }

  $interface   = $name
  $provider    = 'mullvad'
  $config_path = "/etc/openvpn/${name}"

  file { "/etc/openvpn/${name}.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("openvpn/${provider}.conf.erb"),
    notify  => Service['openvpn'],
    require => Package['openvpn'],
  }

  file { $config_path:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['openvpn'],
  } ->
  file { "${config_path}/${name}-up":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0754',
    content => template('openvpn/openvpn-up.erb'),
    notify  => Service['openvpn'],
  } ->
  file { "${config_path}/${name}-down":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0754',
    content => template('openvpn/openvpn-down.erb'),
    notify  => Service['openvpn'],
  }

  file { "/tmp/${name}":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  } ->
  file { "/tmp/${name}/${name}_config.zip":
    ensure => file,
    source => "puppet:///modules/openvpn/configs/${name}_config.zip",
    notify => Exec["unzip ${name}_config"],
  }

  exec { "unzip ${name}_config":
    command     => "unzip -u /tmp/${name}/${name}_config.zip -d /tmp/${name}/",
    refreshonly => true,
    require     => Package['unzip'],
  }

  exec { "mv [0-9]*/${provider}.crt ${config_path}/${name}.crt":
    cwd         => "/tmp/${name}/",
    refreshonly => true,
    subscribe   => Exec["unzip ${name}_config"],
    require     => File[$config_path],
  } ->
  file { "${config_path}/${name}.crt":
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    notify => Service['openvpn'],
  }

  exec { "mv [0-9]*/${provider}.key ${config_path}/${name}.key":
    cwd         => "/tmp/${name}/",
    refreshonly => true,
    subscribe   => Exec["unzip ${name}_config"],
    require     => File[$config_path],
  } ->
  file { "${config_path}/${name}.key":
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    notify => Service['openvpn'],
  }

  exec { "move openvpn-config-files to ${config_path}":
    command     => "mv [0-9]*/ca.crt [0-9]*/crl.pem ${config_path}",
    cwd         => "/tmp/${name}/",
    refreshonly => true,
    subscribe   => Exec["unzip ${name}_config"],
    require     => File[$config_path],
  } ->
  file { [ "${config_path}/ca.crt", "${config_path}/ca.pem"]:
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    notify => Service['openvpn'],
  }

  exec { "check for ${interface}":
    command => 'true ', # please keep it there as a command, not as a bool
    unless  => "ifconfig | grep ${interface}",
    notify  => Service['openvpn'],
  }

}
