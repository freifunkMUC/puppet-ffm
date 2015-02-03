class openvpn::service {

  service { 'openvpn':
    ensure => running,
    notify => Exec[$::openvpn::notify_exec],
  }

}
