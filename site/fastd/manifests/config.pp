class fastd::config {

  include ::fastd::params

  $hex_gateway_number = inline_template("<%= ${::fastd::gateway_number}.to_i.to_s(16) -%>")
  $interface_mac = "${::fastd::mac_prefix}:${hex_gateway_number}:${::fastd::mac_suffix}"

  file { [ '/etc/fastd/', $::fastd::config_path ]:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['fastd'],
  } ->
  file { "${::fastd::config_path}/peers/":
    ensure  => directory,
    recurse => $::fastd::purge_peers,
    purge   => $::fastd::purge_peers,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  } ->
  file { "${::fastd::config_path}/keys.yaml":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('fastd/keys.yaml.erb'),
    notify  => Service['fastd'],
  } ->
  file { "${::fastd::config_path}/secret.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('fastd/secret.conf.erb'),
    notify  => Service['fastd'],
  } ->
  file { "${::fastd::config_path}/fastd-up":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('fastd/fastd-up.erb'),
    notify  => Service['fastd'],
  } ->
  file { "${::fastd::config_path}/fastd.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('fastd/fastd.conf.erb'),
    notify  => Service['fastd'],
  } ->
  file { '/etc/init/fastd.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('fastd/fastd.upstart.erb'),
    notify  => Service['fastd'],
  } ->
  Service['fastd']

}
