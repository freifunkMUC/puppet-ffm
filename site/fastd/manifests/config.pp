class fastd::config {

  include ::fastd::params
  include ::gwlib

  $hex_gateway_number  = int_to_hex( $::fastd::gateway_number )
  $interface_mac = "${::fastd::mac_prefix}:${hex_gateway_number}:${::fastd::mac_suffix}"

  file { [ '/etc/fastd/', $::fastd::params::community_folder ]:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['fastd'],
  } ->
  file { "${::fastd::params::community_folder}/peers/":
    ensure  => directory,
    recurse => $::fastd::purge_peers,
    purge   => $::fastd::purge_peers,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  } ->
  file { "${::fastd::params::community_folder}/keys.yaml":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('fastd/keys.yaml.erb'),
    notify  => Service['fastd'],
  } ->
  file { "${::fastd::params::community_folder}/secret.conf":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('fastd/secret.conf.erb'),
    notify  => Service['fastd'],
  } ->
  file { "${::fastd::params::community_folder}/fastd-up":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('fastd/fastd-up.erb'),
    notify  => Service['fastd'],
  } ->
  file { "${::fastd::params::community_folder}/fastd.conf":
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
