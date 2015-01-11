class batman_adv::module::params {

  $batman_adv_version = hiera('batman_adv_version', '2014.3')

  if $batman_adv_version == '2014.3' {
    warning("You probably did not choose batman_adv_version = ${batman_adv_version} but this is the default.")
  }

  case $::operatingsystem {
    'Debian': {
      $batctl_package = 'batctl'

      case $::hardwaremodel {
        'x86_64': {
          $kernel_package = 'linux-image-amd64'
        }
        default: {
          fail("${::hardwaremodel} is currently not supported!")
        }
      }

      case $::operatingsystemmajrelease {
        'jessie/sid', '8': {
          case $batman_adv_version {
            '2014.3': {
              $batctl_version = '2014.3.0-2'
              $kernel_version = '3.16'
            }
            default: {
              fail("${batman_adv_version} on ${::operatingsystem} ${::operatingsystemmajrelease} is not yet supported!")
            }
          }
        }
        default: {
          fail("${::operatingsystem} ${::operatingsystemmajrelease} is not yet supported!")
        }
      }
    }
    'Ubuntu': {
      $kernel_package = 'linux-image-generic'
      $batctl_package = 'batctl'

      if $::hardwaremodel == 'x86_64' {
        case $::operatingsystemmajrelease {
          '14.04': {
            case $batman_adv_version {
              '2014.3': {
                #$kernel_version = '3.16.0.23.24'
                $kernel_version = '3.16'
                $batctl_version = '2014.3.0-1'
              }
              '2014.4': {
                $kernel_version = '3.18'
                $batctl_version = '2014.4.0-1'
              }
              default: {
                fail("${batman_adv_version} is not yet supported on this system!")
              }
            }
          }
          default: {
            fail("${::operatingsystem} ${::operatingsystemmajrelease} is not yet supported!")
          }
        }
      } else {
        fail("${::operatingsystem} ${::operatingsystemmajrelease} on ${::hardwaremodel} is not supported!")
      }
    }
  }


}
