class iscdhcpd (
  $subnet      = '10.80.0.0',
  $netmask     = '255.255.0.0',
  $range_start = $iscdhcpd::params::range_start,
  $range_end   = $iscdhcpd::params::range_end,
  $dns_servers = $iscdhcpd::params::dns_servers,
  $routers     = $iscdhcpd::params::routers,
) inherits iscdhcpd::params {

  # due to a bug of the isc-dhcp-server-package for debian jessie (4.3.1-1)
  # we need first to provide a configuration with a subnet first. therefore
  # we cannot notify the service on the first puppet run
  file { '/etc/dhcp/dhcpd.conf':
    ensure      => file,
    owner       => 'root',
    group       => 'root',
    mode        => 0644,
    content     => template('iscdhcpd/dhcpd.conf.erb'),
    #notify      => Service['isc-dhcp-server'],
  } ->
  package { 'isc-dhcp-server':
  }

  service { 'isc-dhcp-server':
    ensure   => running,
    require  => Package['isc-dhcp-server'],
  }

}
