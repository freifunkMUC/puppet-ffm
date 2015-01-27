class profiles::stoererhaftung::undefined (
  $vpn_interface,
  $vpn_routing_table,
  $dns_service,
) {

  warning('You have not defined any vpn_service in any yaml-file within the hieradata folder!')

}
