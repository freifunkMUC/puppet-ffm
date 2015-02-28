# Load muc ffmap backend from git and
# install a cronjob to create the nodes file

class profile::ffmapbackend (
  $domain          = $::fqdn,
  $git_repo_url    = 'https://github.com/freifunkMUC/ffmap-backend',
  $git_destination = '/opt/ffmap-backend',) {
    
  $peers_directory = "${::fastd::config_path}/peers"
  $mesh_network_interface = hiera('profile::batman_adv::bridge')
  include ::nginxpack

  nginxpack::vhost::basic { $domain: domains => [$domain], }

  include ::package::git
  
  $destination_directory = "/var/www/${domain}"

  vcsrepo { $git_destination:
    ensure   => latest,
    provider => git,
    source   => $git_repo_url,
    require  => Package['git'],
    revision => 'bat15',
    notify   => Exec['generate_nodesjs'],
  }
  ->
  file { "${git_destination}/mkmap.sh":
     ensure => file,
     content => template("${module_name}/ffmapbackend/mkmap.sh.erb"),
     mode => '0555'  
  }

  $ffmap_command = "${git_destination}/mkmap.sh "

  exec { 'generate_nodesjs':
    command     => $ffmap_command,
    refreshonly => true,
  }

  cron { 'cron_nodesjs':
    command => $ffmap_command,
    minute  => '*/5',
  }
}