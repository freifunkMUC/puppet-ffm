class fastd::install {

  package { 'fastd':
    ensure => $::fastd::version,
  }

}
