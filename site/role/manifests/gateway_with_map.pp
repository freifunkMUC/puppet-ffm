# Installs and configures all services necessary
# for a freifunk-gateway

class role::gateway_with_map {
  include ::role::gateway
  include ::profile::ffmapbackend
  include ::role::community::ffmapfrontend
}
