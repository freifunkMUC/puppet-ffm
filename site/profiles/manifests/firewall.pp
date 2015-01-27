class profiles::firewall (
  $purge = false,
  $batman_bridge,
  $vpn_interface,
) {

  if str2bool($purge) {
    resources { 'firewall':
      purge => true,
    }
  }

  class { '::firewall': }

  firewall { '001 Masquerade VPN Traffic':
    provider => 'iptables',
    chain    => 'POSTROUTING',
    table    => 'nat',
    outiface => $vpn_interface,
    proto    => 'all',
    jump     => 'MASQUERADE',
  }

}
