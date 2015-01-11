class radvd::service {
  service { 'radvd':
    ensure     => running,
    hasrestart => true,
  }
}
