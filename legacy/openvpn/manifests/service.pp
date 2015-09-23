class openvpn::service {

  include ::kmod

  kmod::load { 'tun':
  } ->
  service { 'openvpn':
    ensure => running,
  }

}
