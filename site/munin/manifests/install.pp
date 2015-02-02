class munin::install {

  package { $::munin::params::node_package:
    ensure => present,
  }

}
