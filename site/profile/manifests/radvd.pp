class profile::radvd (
  $ipv6_prefix_without_length,
  $ipv6_prefix_length,
) {

  include ::profile::batman_adv

  class { '::radvd':
    batman_bridge              => $::profile::batman_adv::bridge,
    gateway_number             => $::profile::batman_adv::gateway_number,
    ipv6_prefix_without_length => $ipv6_prefix_without_length,
    ipv6_prefix_length         => $ipv6_prefix_length,
  }

  Exec["/sbin/ifup ${::profile::batman_adv::bridge}"] ~> Service['radvd']

}
