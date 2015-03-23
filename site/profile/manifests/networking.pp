class profile::networking (
  $vpn_routing_table_name = 'freifunk',
  $vpn_routing_table_nr = '42',
) {

  sysctl { 'net.ipv4.ip_forward': value => '1' }
  sysctl { 'net.ipv6.conf.all.forwarding': value => '1' }
  sysctl { 'net.ipv4.conf.default.rp_filter': value => '2' }
  sysctl { 'net.ipv4.conf.all.rp_filter': value => '2' }
  sysctl { 'net.core.default_qdisc': value => 'fq_codel' }

  # Increase Linux autotuning TCP buffer limits
  # Set max to 16MB for 1GE and 32M (33554432) or 54M (56623104) for 10GE
  # Don't set tcp_mem itself! Let the kernel scale it based on RAM.
  sysctl { 'net.core.rmem_max': value => '16777216' }
  sysctl { 'net.core.wmem_max': value => '16777216' }
  sysctl { 'net.core.rmem_default': value => '16777216' }
  sysctl { 'net.core.wmem_default': value => '16777216' }
  sysctl { 'net.core.optmem_max': value => '40960' }
  sysctl { 'net.ipv4.tcp_rmem': value => '4096 87380 16777216' }
  sysctl { 'net.ipv4.tcp_wmem': value => '4096 65536 16777216' }

  # Make room for more TIME_WAIT sockets due to more clients,
  # and allow them to be reused if we run out of sockets
  # Also increase the max packet backlog
  sysctl { 'net.core.netdev_max_backlog': value => '50000' }
  sysctl { 'net.ipv4.tcp_max_syn_backlog': value => '30000' }
  sysctl { 'net.ipv4.tcp_max_tw_buckets': value => '2000000' }
  sysctl { 'net.ipv4.tcp_tw_reuse': value => '1' }
  sysctl { 'net.ipv4.tcp_fin_timeout': value => '10' }

  # Disable TCP slow start on idle connections
  sysctl { 'net.ipv4.tcp_slow_start_after_idle': value => '0' }

  # Disable source routing and redirects
  sysctl { 'net.ipv4.conf.all.send_redirects': value => '0' }
  sysctl { 'net.ipv4.conf.all.accept_redirects': value => '0' }
  sysctl { 'net.ipv4.conf.all.accept_source_route': value => '0' }

  augeas { 'routing table':
    context => '/files/etc/iproute2/rt_tables',
    changes => "set ${vpn_routing_table_name} ${vpn_routing_table_nr}",
    onlyif  => "match ${vpn_routing_table_name}[. = '${vpn_routing_table_nr}'] size == 0",
    incl    => '/etc/iproute2/rt_tables',
    lens    => 'IPRoute2.lns',
  }

}
