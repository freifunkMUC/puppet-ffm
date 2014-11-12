# Installs and configures all services necessary
# for a freifunk gateway (ffm config)

class ffm::roles::freifunk_gateway {
  include ffm::profiles::batman_advanced
  include ffm::profiles::fastd
  include ffm::profiles::gateway_networking
  include ffm::profiles::dhcp
}
