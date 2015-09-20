class iscdhcpd::service {
  service { 'dhcpd':
    ensure     => running,
    name       => $::iscdhcpd::params::service_name,
    hasrestart => true,
  }
}
