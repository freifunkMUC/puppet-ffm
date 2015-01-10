class iscdhcpd (
  $subnet  = '10.80.0.0',
  $netmask = '255.255.0.0',
  $gateway_number,
) {

  $range_start = "10.80.${gateway_number}.1"
  $range_end   = "10.80.${gateway_number}.254"
  $dns_servers = [ "10.80.0.${gateway_number}" ]
  $routers     = "10.80.0.${gateway_number}"

  file { '/etc/dhcp/dhcpd.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('iscdhcpd/dhcpd.conf.erb'),
  } ->
  package { 'isc-dhcp-server':
  }

  # due to a bug of the isc-dhcp-server-package for debian jessie (4.3.1-1)
  # we need first to provide a configuration with a subnet first. therefore
  # we cannot notify the service on the first puppet run
  if $::lsbdistdescription != 'Debian GNU/Linux testing (jessie)' {
    File['/etc/dhcp/dhcpd.conf'] ~> Service['isc-dhcp-server']
  }

  service { 'isc-dhcp-server':
    ensure     => running,
    hasrestart => true,
    require    => Package['isc-dhcp-server'],
  }

}
