# Installs and configures all services necessary
# for a freifunk gateway (ffm config)

class roles::freifunk_gateway {
  include profiles::apt
  include profiles::batman_advanced
  include profiles::fastd
  include profiles::gateway_networking
  include profiles::dhcpd
}
