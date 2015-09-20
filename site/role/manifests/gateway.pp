class role::gateway {
  contain ::profile::default
  contain ::profile::gateway

  # include ::profile::firewall
  # include ::profile::openvpn
}
