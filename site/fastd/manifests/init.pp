define fastd (
  $secret,
  $public,
  $bind="any:10000",
  $mode='tap',
  $mtu=1426,
  $methods=["salsa2012+umac"],
  $user="fastd-${name}",
  $group="fastd-${name}",
  $on_up="/sbin/ip link set ${name} up",
  $verify_all=false,
  $log_level="info",
  $peers={},
) {
  $service_name="fastd@${name}"

  ensure_packages(['fastd'], { ensure => installed });

  group { $group:
    ensure => present,
    system => true,
  } ->

  user { $user:
    ensure => present,
    gid    => $group,
    shell  => "/bin/true",
    system => true,
  } ->

  file { ["/etc/fastd/${name}", "/etc/fastd/${name}/peers"]:
    ensure => directory,
  } ->

  file { "/etc/fastd/${name}/fastd.conf":
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => "0600",
    content => template('fastd/fastd.conf.erb'),
  } ~>

  service { $service_name:
    ensure   => running,
    enable   => true,
    provider => 'systemd',
  }

  Fastd::Peer {
    instance => $name,
    notify   => Service[$service_name],
  }

  ::fastd::peer { "${name}-${fqdn}":
    key  => $public,
    path => "/etc/fastd/${name}/${fqdn}",
  }

  validate_hash($peers)
  each($peers) |$peer, $args| {
    create_resources('::fastd::peer', { "${name}-${peer}" => merge({ name => $peer }, $args) })
  }
}
