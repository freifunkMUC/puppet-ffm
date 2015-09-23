define fastd::peer (
  $instance,
  $key,
  $remotes=[],
  $float='no',
  $path="/etc/fastd/${instance}/peers/${name}"
) {
  file { $path:
    ensure  => file,
    content => template('fastd/peer.erb'),
    notify  => Service["fastd@${instance}"],
  }
}
