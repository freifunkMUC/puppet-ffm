class iscdhcpd::service {
  service { 'isc-dhcp-server':
    ensure     => running,
    hasrestart => true,
  }
}
