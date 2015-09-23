class openvpn::install {

  package { 'openvpn':
    ensure => $::openvpn::ensure,
  }

}
