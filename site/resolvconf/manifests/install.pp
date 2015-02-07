class resolvconf::install {

  package { 'resolvconf':
    ensure => $::resolvconf::ensure,
  }

}
