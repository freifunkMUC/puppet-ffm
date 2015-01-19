class profiles::alfred (
  $alfred_json_version = '0.3.1-1',
) {

  include ::batman_adv

  case $::operatingsystem {
    'Ubuntu': {
      package { 'libgps21':
        ensure => '3.11*',
      } ->
      file { "/tmp/alfred_${::batman_adv::version}_amd64.deb":
        source => "puppet:///modules/profiles/alfred_${::batman_adv::version}_amd64.deb",
      } ->
      package { 'alfred':
        ensure   => latest, # if this is not here, we wont get an updated package
        provider => 'dpkg',
        source   => "/tmp/alfred_${::batman_adv::version}_amd64.deb",
      } ->
      package { 'zlib1g':
        ensure => installed,
      } ->
      package { 'libjansson4':
        ensure => installed,
      } ->
      file { "/tmp/alfred-json_${alfred_json_version}_amd64.deb":
        source => "puppet:///modules/profiles/alfred-json_${alfred_json_version}_amd64.deb",
      } ->
      package { 'alfred-json':
        ensure   => latest, # if this is not here, we wont get an updated package
        provider => 'dpkg',
        source   => "/tmp/alfred-json_${alfred_json_version}_amd64.deb",
      }
    }
    default: {
      notify { "alfred is currently not supported for ${::operatingsystem}!": }
    }
  }


}
