class role::gateway {
  contain ::profile::gateway

  # include ::profile::firewall
  # include ::profile::openvpn
}
