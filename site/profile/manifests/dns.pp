class profile::dns (
  $upstream_servers = [ '85.214.20.141', '213.73.91.35' ],
  $listen_address = '127.0.0.1',
) {

  include ::profile::batman_adv

  $openvpn_configs = $::profile::openvpn::configs
  $batman_bridge   = $::profile::batman_adv::bridge

  $dns_service = 'dnsmasq'
  $dns_interfaces = [ $batman_bridge ]

  if $openvpn_configs == 'undefined' {
    include ::openvpn::undefined
    $forward_interfaces = [$::openvpn::undefined::interface]
  } else {
    $forward_interfaces = keys($openvpn_configs)
  }

  if $::osfamily == 'Debian' {
    include ::resolvconf
  }

  class { "::${dns_service}":
    dns_interfaces     => $dns_interfaces,
    no_dhcp_interface  => $batman_bridge,
    forward_interfaces => $forward_interfaces,
    upstream_servers   => $upstream_servers,
    listen_address     => $listen_address,
  }

  Exec["/sbin/ifup ${batman_bridge}"] ~> Service['dns']
}
