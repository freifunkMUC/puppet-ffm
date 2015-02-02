class munin::service {

  service { $::munin::params::service:
    ensure => running,
  }

}
