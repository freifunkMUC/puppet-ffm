class munin::config {

  file { '/etc/munin/munin-node.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('munin/munin-node.conf.erb'),
    notify  => Service['munin-node'],
    require => Package["$::munin::params::node_package"],
  }

}
