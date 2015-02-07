class radvd (
  $batman_bridge,
  $ipv6_prefix_without_length,
  $ipv6_prefix_length,
  $gateway_number,
  $ensure = 'installed',
) {
  include ::radvd::install
  include ::radvd::config
  include ::radvd::service

  if ! is_integer($gateway_number) {
    fail('gateway_number is not an integer!')
  } elsif $gateway_number < 0 or $gateway_number > 255 {
    fail('gateway_number is either < 0 or > 255 which is not supported right now!')
  }

}
