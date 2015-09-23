class dnsmasq::install {

  package { 'dnsmasq':
    ensure => $::dnsmasq::ensure,
  }

}
