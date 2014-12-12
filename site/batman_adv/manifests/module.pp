class batman_adv::module (
  $version = '2014.3.0',
  $batctl_minor_version = '2',
) {
  include kmod

  Exec { path => [ '/usr/local/sbin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/bin', '/bin' ] }
  Kmod::Load { notify => Service['fastd'] }

  case $::operatingsystem {
    'Debian': {
      if $::operatingsystemmajrelease == 'jessie/sid' {
        kmod::load { 'batman_adv':
        } ->
        package { 'batctl':
          ensure => "${version}-${batctl_minor_version}",
        }
      } else {
        fail("${::operatingsystemmajrelease} is not yet supported!")
      }
    }
    'Ubuntu': {
      if $::operatingsystemmajrelease == '14.04' {
        $old_version = '2013.4.0'

        package { 'batman-adv-dkms':
        } ->
        package { 'batman-adv-source':
        } ->
        package { 'batctl':
          ensure => "${version}-${batctl_minor_version}",
        } ->
        exec { "dkms remove batman-adv/${old_version} --all":
          unless => "test -n \"\$( dkms status -m batman-adv/${old_version} )\"",
        } ->
        exec { "git clone http://git.open-mesh.org/batman-adv.git batman-adv-${version}":
          cwd    => '/usr/src',
          unless => "stat /usr/src/batman-adv-${version}",
        } ->
        exec { "git checkout v${version}":
          cwd => "/usr/src/batman-adv-${version}",
        } ->
        file { "/usr/src/batman-adv-${version}/dkms.conf":
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => 0644,
          content => template('batman_adv/dkms.conf.erb'),
        } ->
        exec { "dkms --force install batman-adv/${version}":
        } ->
        kmod::load { 'batman_adv':
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
