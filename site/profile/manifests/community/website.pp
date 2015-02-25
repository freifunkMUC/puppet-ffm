# Installs
# Loads the freifunk website from a git repo and
# runs static file generation with jekyll
# on subsequent runs gets latest repo content and
# runs exec

class profile::community::website (
  $domain          = 'website.freifunk-muenchen.de',
  $git_repo_url    = 'https://github.com/freifunkMUC/freifunkmuc.github.io.git',
  $git_destination = '/opt/gitrepo-freifunk-website',) {
  include ::nginxpack

  nginxpack::vhost::basic { $domain:
    domains => [$domain],
    before  => Exec['generate_website'],
    notify  => Exec['generate_website'],
  }

  include ::git

  vcsrepo { $git_destination:
    ensure   => latest,
    provider => git,
    source   => $git_repo_url,
    require  => Class['git'],
    revision => 'master',
    before   => Exec['generate_website'],
  }

  package { 'jekyll': ensure => present } ->
  exec { 'generate_website':
    command     => "/usr/bin/jekyll $git_destination /var/www/$domain",
    refreshonly => true,
    subscribe   => Vcsrepo[$git_destination]
  }
}