class profile::openvpn (
  $configs = 'undefined',
) {

  include ::profile::networking

  if $configs != 'undefined' {
    class { '::openvpn':
      configs => $configs,
    }
  } else {
    class { '::openvpn::undefined':
      routing_table => $::profile::networking::vpn_routing_table_name,
    }
  }

}
