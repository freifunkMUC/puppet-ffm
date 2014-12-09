class iscdhcpd::params {
  $gateway_number = hiera('gateway_number')

  $range_start = "10.80.${gateway_number}.1"
  $range_end   = "10.80.${gateway_number}.254"
  $dns_servers = [ "10.80.0.${gateway_number}" ]
  $routers     = "10.80.0.${gateway_number}"

}
