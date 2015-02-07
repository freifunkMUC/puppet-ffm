# vim: set sw=2 sts=2 et tw=80 :
class batman_adv (
  $bridge,
  $gateway_number,
  $gateway_ip,
  $vpn_routing_table,
  $netmask,
  $version,
  $ipv6_prefix_without_length,
  $download_bandwidth = 10,
  $upload_bandwidth = 5,
) {
  contain ::batman_adv::install
  contain ::batman_adv::config

  if ! is_integer($gateway_number) {
    fail('gateway_number is not an integer!')
  } elsif $gateway_number < 0 or $gateway_number > 255 {
    fail('gateway_number is either < 0 or > 255 which is not supported right now!')
  }

  validate_ipv4_address($gateway_ip)
  validate_ipv4_address($netmask)

  if ! is_integer($download_bandwidth) {
    fail('download_bandwidth is not an integer!')
  } elsif $download_bandwidth < 0 {
    fail('download_bandwidth cannot be < 0!')
  }

  if ! is_integer($upload_bandwidth) {
    fail('upload_bandwidth is not an integer!')
  } elsif $upload_bandwidth < 0 {
    fail('upload_bandwidth cannot be < 0!')
  }

}
