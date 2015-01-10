class profiles::networking (
  $fastd_connection_interface,
  $default_gateway_ip = undef,
  $gateway_number,
  $mesh_vpn_interface,
  $vpn_routing_table_nr,
) {

  include profiles::dns

  $batman_bridge = hiera('batman_bridge')

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
    notify  => Service['dns'],
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

  # very hackish...
  $runs_on_box_behind_nat = hiera('runs_on_box_behind_nat')
  if str2bool($runs_on_box_behind_nat) {
    $internal_fastd_connection_ip = inline_template(
      "<%= scope.lookupvar('::ipaddress_${fastd_connection_interface}') -%>")

    if $default_gateway_ip != undef {
      exec { "ip route del default; ip route add default via ${default_gateway_ip} dev ${fastd_connection_interface}":
        path    => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin/:/usr/sbin/:/sbin',
        unless  => "ip route show | grep 'default via ${default_gateway_ip}'",
        require => File['/etc/network/interfaces.d/batman.cfg'],
      }
    }

  }

}
