class profile::batman_adv (
  $bridge,
  $gateway_ip,
  $gateway_number,
  $netmask,
  $version = '2014.3',
) {

  include ::profile::networking
  include ::profile::radvd

  if $version == '2014.3' {
    warning("You probably did not choose batman-advanced-version = ${version} but this is the default.")
  }

  class { '::batman_adv':
    version                    => $version,
    bridge                     => $bridge,
    gateway_number             => $gateway_number,
    gateway_ip                 => $gateway_ip,
    netmask                    => $netmask,
    vpn_routing_table          => $::profile::networking::vpn_routing_table_name,
    ipv6_prefix_without_length => $::profile::radvd::ipv6_prefix_without_length,
  }

}

