class iscdhcpd (
  $subnet,
  $netmask,
  $range_start,
  $range_end,
  $gateway_ip,
  $dns_servers = [ $gateway_ip ],
  $routers = [ $gateway_ip ],
  $default_lease_time = 600,
  $max_lease_time = 7200,
) {

  include ::iscdhcpd::service

  file { '/etc/dhcp/dhcpd.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('iscdhcpd/dhcpd.conf.erb'),
  } ->
  package { 'isc-dhcp-server':
  } ->
  Service['isc-dhcp-server']

  # due to a bug of the isc-dhcp-server-package for debian jessie (4.3.1-1)
  # we need first to provide a configuration with a subnet first. therefore
  # we cannot notify the service on the first puppet run
  if $::lsbdistdescription != 'Debian GNU/Linux testing (jessie)' {
    File['/etc/dhcp/dhcpd.conf'] ~> Service['isc-dhcp-server']
  }

}
