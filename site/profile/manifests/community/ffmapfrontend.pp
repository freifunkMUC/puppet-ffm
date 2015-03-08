class profile::community::ffmapfrontend (
  $domain = $::fqdn,
  $nodesjson_downloadurl = 'http://map.freifunk-muenchen.de/nodes.json',
  $cityname = 'Muenchen',
  $sitename = 'www.freifunk-muenchen.de',
  $siteurl = 'http://www.freifunk-muenchen.de'
) {

  include ::nodejs
  include ::package::git
  include ::nginxpack

  $target_folder = '/var/www'
  $owner = 'www-data'
  $group = 'www-data'
  $commit = 'master'
  $www_root = "${target_folder}/${domain}"


  file { $target_folder:
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  file { $www_root:
    ensure => directory,
    owner  => $owner,
    group  => $group,
  } ->
  vcsrepo { $www_root:
    ensure   => present,
    provider => 'git',
    source   => 'https://github.com/ffnord/ffmap-d3.git',
    revision => $commit,
    require  => [Package['git'],File[$www_root]]
  } ->
    nginxpack::vhost::basic { $domain:
    domains   => [$domain],
    files_dir => "${www_root}/build"
  } ->
  package { 'grunt-cli':
    ensure   => present,
    provider => 'npm',
    require  => Class['::nodejs'],
  } ->
  package { 'bower':
    ensure   => present,
    provider => 'npm',
  } ->
  exec { 'ffmap: npm install':
    command => 'npm install',
    cwd     => $www_root,
    require => Vcsrepo[$www_root],
  } ->
  exec { 'ffmap: bower install':
    command => 'bower install --allow-root -q',
    cwd     => $www_root,
  } ->
  file { "${www_root}/config.json":
    ensure  => file,
    content => template("${module_name}/community/ffmapfrontend/config.json.erb"),
    notify  => Exec['ffmap: grunt']
  } ->
  file { "${www_root}/config.js":
    ensure  => file,
    content => template("${module_name}/community/ffmapfrontend/config.js.erb"),
    notify  => Exec['ffmap: grunt']
  } ->
  exec { 'ffmap: grunt':
    command     => "rm -rf ${www_root}/build ; grunt",
    environment => ['HOME=/root'],
    cwd         => $www_root,
  } ->
  file { "${www_root}/build":
    recurse => true,
    owner   => $owner,
    group   => $group,
  } ->
  file { "${www_root}/build/index.html":
    ensure => link,
    target => "${www_root}/build/geomap.html",
    owner  => $owner,
    group  => $group,
  } ->
  exec { 'retrieve nodes.json':
    command => "wget -q ${nodesjson_downloadurl} -O ${www_root}/build/nodes.json",
    creates => "${www_root}/build/nodes.json",
  }

  cron { 'ffmap: retrieve nodes.json':
    command => "wget -q ${nodesjson_downloadurl} -O ${www_root}/build/nodes.json",
    user    => $owner,
    minute  => '*/5',
    require => File["${www_root}/build"]
  }
}
