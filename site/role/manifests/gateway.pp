class role::gateway {
  contain ::profile::default
  contain ::profile::gateway

  contain ::accounts

  # include ::profile::monitoring
  # include ::profile::firewall
  # include ::profile::openvpn
}
