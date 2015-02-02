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
  $mesh_vpn_interface,
  $community,
  $gateway_number,
) {

  class { '::fastd':
    mesh_vpn_interface => $mesh_vpn_interface,
    community          => $community,
    gateway_number     => $gateway_number,
  }
  contain ::fastd

}
