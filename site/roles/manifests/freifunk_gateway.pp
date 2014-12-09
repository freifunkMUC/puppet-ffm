# Installs and configures all services necessary
# for a freifunk gateway (ffm config)

class roles::freifunk_gateway {
  include profiles::etckeeper
  include profiles::firewall
  include gluonconfig
  include profiles::apt
  include profiles::fastd
  include profiles::networking
  include profiles::dhcpd
  include profiles::dns

  include profiles::alfred
}

