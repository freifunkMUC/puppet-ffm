class profile::gateway {
  require ::component::apt

  contain ::component::alfred
  contain ::component::batman
  contain ::component::dnsmasq
}
