# Installs and configures all services necessary
# for a freifunk-gateway

class role::gateway {
  include ::profile::apt
  include ::profile::monitoring
  include ::profile::firewall
  include ::profile::openvpn
  include ::profile::alfred
  include ::profile::networking
  include ::profile::dns
  include ::profile::dhcpd
  include ::etckeeper
  include ::gluonconfig
}
