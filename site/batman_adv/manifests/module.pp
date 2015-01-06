# vim: set sw=2 sts=2 et tw=80 :
class batman_adv::module (
  $version = '2014.3.0',
  $batctl_minor_version = '2',
) {
  include kmod

  Exec { path => [ '/usr/local/sbin', '/usr/sbin',
    '/sbin', '/usr/local/bin', '/usr/bin', '/bin' ] }
  Kmod::Load { notify => Service['fastd'] }

  case $::operatingsystem {
    'Debian': {
      case $::operatingsystemmajrelease {
        'jessie/sid', '8': {
          kmod::load { 'batman_adv': } ->
          package { 'batctl':
            ensure => "${version}-${batctl_minor_version}",
          }
        }
        default: {
          fail("${::operatingsystemmajrelease} is not yet supported!")
        }
      }
    }
    'Ubuntu': {
      if $::operatingsystemmajrelease == '14.04' {
        if $::kernelmajversion != '3.16' {
          $ubuntu_kernelversion = hiera('ubuntu_kernelversion')
          package { 'linux-image-generic':
            ensure => $ubuntu_kernelversion,
          } ->
          notify { 'You need to reboot first with your new kernel!': }
        }

        if $::hardwaremodel == 'x86_64' {
          kmod::load { 'batman_adv':
          } ->
          package { 'libnl-3-200':
          } ->
          file { '/tmp/batctl_2014.3.0-1_amd64.deb':
            source => 'puppet:///modules/batman_adv/batctl_2014.3.0-1_amd64.deb',
          } ->
          package { 'batctl':
            provider => 'dpkg',
            source   => '/tmp/batctl_2014.3.0-1_amd64.deb',
          }
        } else {
          fail("${::operatingsystem} ${::operatingsystemmajrelease} on ${::hardwaremodel} is not supported!")
        }
      } else {
        fail("${::operatingsystem} ${::operatingsystemmajrelease} is not yet supported!")
      }
    }
    default: {
      fail("${::operatingsystem} is not yet supported!")
    }
  }

}
