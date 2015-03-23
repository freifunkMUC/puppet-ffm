class profile::networking (
  $vpn_routing_table_name = 'freifunk',
  $vpn_routing_table_nr = '42',
) {

  sysctl { 'net.ipv4.ip_forward': value => '1' }
  sysctl { 'net.ipv6.conf.all.forwarding': value => '1' }
  sysctl { 'net.ipv4.conf.default.rp_filter': value => '2' }
  sysctl { 'net.ipv4.conf.all.rp_filter': value => '2' }
  sysctl { 'net.core.default_qdisc': value => 'fq_codel' }

  augeas { 'routing table':
    context => '/files/etc/iproute2/rt_tables',
    changes => "set ${vpn_routing_table_name} ${vpn_routing_table_nr}",
    onlyif  => "match ${vpn_routing_table_name}[. = '${vpn_routing_table_nr}'] size == 0",
    incl    => '/etc/iproute2/rt_tables',
    lens    => 'IPRoute2.lns',
  }

}
