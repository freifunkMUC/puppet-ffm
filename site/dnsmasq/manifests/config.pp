class dnsmasq::config {

  file { '/etc/dnsmasq.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['dnsmasq'],
    content => template('dnsmasq/dnsmasq.conf.erb'),
  } ->
  file { '/etc/dnsmasq.d/rules':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dnsmasq/rules.erb'),
    require => Package['dnsmasq'],
  }

  File['/etc/dnsmasq.conf'] ~> Service['dns']
  File['/etc/dnsmasq.d/rules'] ~> Service['dns']

}
