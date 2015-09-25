class profile::gateway (
  $ipv4,
  $ipv6,
  $interface='bat0',
  $bridge_name='br0',
  $tunnel_name='tun0',
) {
  require ::component::apt

  contain ::component::alfred
  contain ::component::batman
  contain ::component::dnsmasq

  class { '::component::fastd':
    up => ["batctl -m ${interface} if add \$IFACE"],
  }
  contain ::component::fastd

  network::interface { "${name}-v4":
    interface => $bridge_name,
    family    => 'inet',
    ipaddress => $ipv4,
    bridge_ports => [$interface],
    allow_hotplug => true,
    up => [
      'ip rule add iif $IFACE table 42',
      'ip route add unreachable default table 42',
    ],
    down => [
      'ip route del unreachable default table 42',
      'ip rule del iif $IFACE table 42',
    ],
  }

  network::interface { "${name}-v6":
    interface => $bridge_name,
    family    => 'inet6',
    ipaddress => $ipv6,
  }

  network::interface { $interface:
    method => 'manual',
    pre_up => [
      'ip link add bat-dummy type dummy || true',
      "batctl -m ${interface} if add bat-dummy",
    ],
    up     => [
      "batctl -m ${interface} gw mode server 100/100",
      "batctl -m ${interface} it 10000",
      'ip link set $IFACE up',
    ],
  }

  contain ::firewall

  firewall { '000 Masquerade VPN traffic':
    table    => 'nat',
    chain    => 'POSTROUTING',
    proto    => 'all',
    outiface => $tunnel_name,
    jump     => 'MASQUERADE',
  }

  firewallchain { 'FORWARD:filter:IPv4':
    ensure => present,
    policy => drop,
    before => undef,
  }

  firewallchain { 'FORWARD:filter:IPv6':
    ensure => present,
    policy => drop,
    before => undef,
  }

  firewall { '000 Allow bridge to tunnel forwarding':
    chain    => 'FORWARD',
    iniface  => $tunnel_name,
    outiface => $bridge_name,
    action   => 'accept',
  }

  firewall { '000 Allow tunnel to bridge forwarding':
    chain    => 'FORWARD',
    iniface  => $bridge_name,
    outiface => $tunnel_name,
    action   => 'accept',
  }

}
