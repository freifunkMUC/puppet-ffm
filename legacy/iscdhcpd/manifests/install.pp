class iscdhcpd::install {
  package { $::iscdhcpd::params::package:
    ensure => $::iscdhcpd::ensure,
  }
}
