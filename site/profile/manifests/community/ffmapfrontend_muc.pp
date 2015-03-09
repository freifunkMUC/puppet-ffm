class profile::community::ffmapfrontend_muc (
  $domain = $::fqdn,
  $nodesjson_downloadurl = 'http://map.freifunk-muenchen.de/nodes.json',
  $cityname = 'Muenchen',
  $sitename = 'www.freifunk-muenchen.de',
  $siteurl = 'http://www.freifunk-muenchen.de',
  $ffmap_repo = 'https://github.com/freifunkMUC/ffmap',
  $ffmap_revision = 'master',
) {

  include ::package::nodejs
  include ::package::git
  include ::nginxpack

  $target_folder = '/var/www'
  $owner = 'www-data'
  $group = 'www-data'
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
  vcsrepo { "$www_root/build":
    ensure   => present,
    provider => 'git',
    source   => $ffmap_repo,
    revision => $ffmap_revision,
    require  => [Package['git'],File[$www_root]]
  } ->
    nginxpack::vhost::basic { $domain:
    domains   => [$domain],
    files_dir => "${www_root}/build"
  }
  
  cron { 'ffmap: retrieve nodes.json':
    command => "wget -q ${nodesjson_downloadurl} -O ${www_root}/build/nodes.json.new ; mv ${www_root}/build/nodes.json.new ${www_root}/build/nodes.json",
    user    => $owner,
    minute  => '*/1',
    require => File["${www_root}/build"]
  }
}
