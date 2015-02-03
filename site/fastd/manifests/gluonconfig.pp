# vim: set sw=2 sts=2 et tw=80 :
class fastd::gluonconfig {

  include ::fastd::params

  # in the future we will manage that with puppetdb
  file { "${::fastd::params::community_folder}/fastd-router-snippet":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('fastd/fastd-router-snippet.erb'),
    require => File[$::fastd::params::community_folder],
  }

}
