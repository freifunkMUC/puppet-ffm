class role::gateway {
  contain ::profile::default

  # contain ::profile::gateway
  # include ::profile::monitoring
  # include ::profile::firewall
  # include ::profile::openvpn
}
