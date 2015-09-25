class component::fastd (
  $instances,
  $defaults={},
  $up=[],
) {
  validate_hash($instances)

  network::interface { keys($instances):
    method => 'manual',
    up => ['ip link set $IFACE up'],
    post_up => $up,
    allow_hotplug => true,
    before => Anchor['fastd-network-config'],
  }

  anchor {'fastd-network-config': }

  create_resources('::fastd', $instances, merge($defaults, {
    require   => Anchor['fastd-network-config'],
  }))
}
