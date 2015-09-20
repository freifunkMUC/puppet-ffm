class munin (
  $munin_master_ipv4_regex = '127\.0\.0\.1',
  $munin_master_ipv6_regex = '::1',
  $bind_interface = 'lo',
) {
  $bind_address = inline_template(
                    "<%= scope['::ipaddress_${bind_interface}'] -%>"
                  )

  include ::munin::params
  include ::munin::install
  include ::munin::config
  include ::munin::service

}

