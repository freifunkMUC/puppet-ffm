class profile::alfred {

  include ::profile::batman_adv
  include ::profile::fastd

  class { '::alfred':
    version => $::profile::batman_adv::version,
  }

  Package['alfred'] -> Service['fastd']
  Package['alfred'] ~> Service['fastd']

}
