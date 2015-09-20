# vim: set sw=2 sts=2 et tw=80 :
class batman_adv::module {

  include kmod
  include batman_adv::module::params

  case $::operatingsystem {
    'Debian': {
      case $::operatingsystemmajrelease {
        'jessie/sid', '8': {
          kmod::load { 'batman_adv': } ->
          package { $::batman_adv::module::params::batctl_package:
            ensure => "${::batman_adv::module::params::batctl_version}*",
          }
        }
        default: {
          fail("${::operatingsystemmajrelease} is not yet supported!")
        }
      }
    }
    'Ubuntu': {
      if $::kernelmajversion != $::batman_adv::module::params::kernel_version {
        package { $::batman_adv::module::params::kernel_package:
          ensure => "${::batman_adv::module::params::kernel_version}*",
        } ->
        package { 'linux-image-extra-generic':
          name => "linux-image-extra-${::batman_adv::module::params::kernel_version}.*-generic",
        }
        warning('You will have to reboot with your new kernel!')
      }

      kmod::load { 'batman_adv':
      } ->
      package { 'libnl-3-200':
      } ->
      package { 'batctl':
        ensure   => latest, # if this is not here, we wont get an updated package
      }
    }
    default: {
      fail("${::operatingsystem} is not yet supported!")
    }
  }

}
