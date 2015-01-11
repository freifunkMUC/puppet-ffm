# vim: set sw=2 sts=2 et tw=80 :
class batman_adv::module (
  $kernel_version = $batman_adv::module::params::kernel_version,
  $kernel_package = $batman_adv::module::params::kernel_package,
  $batctl_version = $batman_adv::module::params::batctl_version,
  $batctl_package = $batman_adv::module::params::batctl_package,
) inherits batman_adv::module::params {

  include kmod

  Kmod::Load { notify => Service['fastd'] }

  case $::operatingsystem {
    'Debian': {
      case $::operatingsystemmajrelease {
        'jessie/sid', '8': {
          kmod::load { 'batman_adv': } ->
          package { $batctl_package:
            ensure => "${batctl_version}*",
          }
        }
        default: {
          fail("${::operatingsystemmajrelease} is not yet supported!")
        }
      }
    }
    'Ubuntu': {
      if $::kernelmajversion != $kernel_version {
        package { 'linux-image-generic':
          ensure => "${kernel_version}*",
        } ->
        package { 'linux-image-extra-generic':
          name => "linux-image-extra-${kernel_version}.*-generic",
        }
        warning('You need to reboot with your new kernel!')
      }

      kmod::load { 'batman_adv':
      } ->
      package { 'libnl-3-200':
      } ->
      file { "/tmp/batctl_${batctl_version}_amd64.deb":
        source => "puppet:///modules/batman_adv/batctl_${batctl_version}_amd64.deb",
      } ->
      package { 'batctl':
        provider => 'dpkg',
        ensure   => latest,
        source   => "/tmp/batctl_${$batctl_version}_amd64.deb",
      }
    }
    default: {
      fail("${::operatingsystem} is not yet supported!")
    }
  }

}
