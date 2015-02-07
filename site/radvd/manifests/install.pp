class radvd::install {
  package { 'radvd':
    ensure => $::radvd::ensure,
  }
}
