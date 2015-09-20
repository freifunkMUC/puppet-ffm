class iscdhcpd (
  $subnet,
  $netmask,
  $range_start,
  $range_end,
  $interface,
  $gateway_ip,
  $ensure = 'installed',
  $dns_servers = [ $gateway_ip ],
  $routers = [ $gateway_ip ],
  $default_lease_time = 300,
  $max_lease_time = 600,
) {

  include ::iscdhcpd::params
  include ::iscdhcpd::install
  include ::iscdhcpd::config
  include ::iscdhcpd::service

  validate_ipv4_address($subnet)
  validate_ipv4_address($netmask)
  validate_ipv4_address($range_start)
  validate_ipv4_address($range_end)
  validate_ipv4_address($gateway_ip)

  if ! is_integer($default_lease_time) {
    fail('default_lease_time is not an integer!')
  } elsif $default_lease_time < 0 {
    fail('default_lease_time cannot be < 0!')
  }

  if ! is_integer($max_lease_time) {
    fail('max_lease_time is not an integer!')
  } elsif $max_lease_time < 0 {
    fail('max_lease_time cannot be < 0!')
  }

}
