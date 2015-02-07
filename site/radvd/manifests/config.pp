class radvd::config {

  $hex_gateway_number = inline_template("<%= ${::radvd::gateway_number}.to_i.to_s(16) -%>")
  $RDNSS              = "${::radvd::ipv6_prefix_without_length}${hex_gateway_number}"

  file { '/etc/radvd.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('radvd/radvd.conf.erb'),
    require => Package['radvd'],
    notify  => Service['radvd'],
  }

}
