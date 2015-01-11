class fastd::service {
  service { 'fastd':
    ensure     => running,
    hasrestart => true,
  }
}
