# Installs and configures fastd

# Requirements
# https://github.com/freifunkMUC/freifunkmuc.github.io/wiki/mesh-VPN-Server-installieren#installation-von-batman-adv-und-fastd
#  
#   * peers aus git (vcsrepo modul)
#   * config
#     * crypto algorithms (salsa2012+gmac, salsa2012+umac)
#     * binds
#     * MTU
#   * networking
#     * MAC
#     * IPv4/IPv6

class profiles::fastd (
  $version = 'present',
  $secret_key,
  $interface,
  $mac,
  $ipv4_address,
  $ipv4_gw,
  $ipv6_address,
  $ipv6_gw,
) {
  package { 'fastd':
    ensure => $version,
  }

  service { 'fastd':
    ensure => running,
    enable => true,
  }
}
