# Installs and configures all services necessary
# for a freifunk gateway (ffm config)

class roles::freifunk_gateway {
  include profiles::etckeeper

  $fastd_connection_interface = hiera('fastd_connection_interface')
  class { 'profiles::firewall':
    fastd_connection_interface => $fastd_connection_interface,
  }

  class { 'profiles::networking':
    fastd_connection_interface => $fastd_connection_interface,
  }

  include profiles::apt
  include profiles::fastd
  include profiles::dhcpd
  include profiles::dns
  include gluonconfig

  include profiles::alfred
}

