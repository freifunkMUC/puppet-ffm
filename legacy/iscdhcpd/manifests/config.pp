class iscdhcpd::config {
  file { '/etc/dhcp/dhcpd.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('iscdhcpd/dhcpd.conf.erb'),
    require => Package[$::iscdhcpd::params::package],
    notify  => Service['dhcpd'],
  }
}
