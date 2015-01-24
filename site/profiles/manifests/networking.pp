class profiles::networking (
  $batman_bridge,
  $gateway_number,
  $mesh_vpn_interface,
  $vpn_routing_table_nr,
) {

  class { 'batman_adv':
    bridge               => $batman_bridge,
    mesh_vpn_interface   => $mesh_vpn_interface,
    gateway_number       => $gateway_number,
    vpn_routing_table_nr => $vpn_routing_table_nr,
  } ->
  class { 'radvd':
    batman_bridge  => $batman_bridge,
    gateway_number => $gateway_number,
  }

  file { '/etc/rc.local':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profiles/rc.local.erb'),
  }

  exec { '/bin/bash /etc/rc.local':
    subscribe   => File['/etc/rc.local'],
    refreshonly => true,
  }

  sysctl {
    'net.ipv4.ip_forward': value => '1',
  } ->
  sysctl {
    'net.ipv6.conf.all.forwarding': value => '1',
  }
}
