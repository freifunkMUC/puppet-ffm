class batman_adv (
  $bridge,
  $download_bandwidth = '10',
  $upload_bandwidth = '5',
) {
  # default needed due to a kmod-bug which would be fixed with
  # https://github.com/camptocamp/puppet-kmod/pull/25.patch
  Exec { path => [ '/usr/local/sbin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/bin', '/bin' ] }

  include kmod
  include fastd
  include gwlib

  $vpn_routing_table   = hiera('vpn_routing_table_nr')
  $gateway_number      = hiera('gateway_number')
  $hex_gateway_number  = int_to_hex( $gateway_number )

  if $::osfamily != 'Debian' {
    fail('Only Debian is supported right now.')
  }

  kmod::load { 'batman_adv':
  } ->
  package { 'batctl':
  }

  package { 'bridge-utils':
  } ->
  file { '/etc/network/interfaces.d/':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
  } ->
  file { '/etc/network/interfaces.d/batman.cfg':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template('batman_adv/batman.cfg.erb'),
    notify  => Service['fastd'],
  }

  exec { "/sbin/ifup ${bridge}":
    notify  => Service['fastd'],
    unless  => "/sbin/ifconfig | grep ${bridge}",
    require => File['/etc/network/interfaces.d/batman.cfg'],
  }

  # source may include any filenames
  # files for source-directory need to match ^[a-zA-Z0-9_-]+$
  # for this reason, the following snippet is correct
  augeas { 'source batman.cfg':
    context => '/files/etc/network/interfaces',
    changes => 'set source[last()+1] interfaces.d/batman.cfg',
    onlyif  => "match source[. = 'interfaces.d/batman.cfg'] size == 0",
    incl    => '/etc/network/interfaces',
    lens    => 'Interfaces.lns',
  }

  File['/etc/network/interfaces.d/batman.cfg'] -> Augeas['source batman.cfg']
  Augeas['source batman.cfg'] -> Exec["/sbin/ifup ${bridge}"]
}
