class openvpn::service {

  service { 'openvpn':
    ensure => running,
  }

}
