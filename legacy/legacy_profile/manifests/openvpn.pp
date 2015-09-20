class profile::openvpn (
  $configs = undef,
) {

  include ::profile::networking

  if $configs != undef {
    class { '::openvpn':
      configs => $configs,
    }
  } elsif $configs == 'undefined' {
    class { '::openvpn::undefined':
      routing_table => $::profile::networking::vpn_routing_table_name,
    }
  }

}
