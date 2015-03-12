# Installs and configures fastd
class profile::fastd (
  $community,
  $mesh_vpn_interface,
) {

  include ::profile::batman_adv
  include ::package::haveged

  class { '::fastd':
    mesh_vpn_interface => $mesh_vpn_interface,
    config_path        => "/etc/fastd/${community}-mesh-vpn",
    gateway_number     => $::profile::batman_adv::gateway_number,
    require            => Class['::batman_adv'],
  }
  contain ::fastd

  Kmod::Load { notify => Service['fastd'] }

  File['/etc/network/interfaces.d/batman.cfg'] ~> Service['fastd']
  Exec["/sbin/ifup ${::profile::batman_adv::bridge}"] ~> Service['fastd']
}
