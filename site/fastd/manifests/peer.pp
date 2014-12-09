define fastd::peer (
  $community_folder
) {
  include fastd

  file { "${community_folder}/peers/${name}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template('fastd/fastd-peer.erb'),
    require => File["${community_folder}/peers/"],
    notify  => Service['fastd'],
  }

}
