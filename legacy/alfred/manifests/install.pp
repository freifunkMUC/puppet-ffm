class alfred::install {
  package { 'libgps21':
    ensure => $::alfred::params::libgps21_ensure,
  } ->
  file { "/tmp/alfred_${::alfred::version}_${::alfred::params::arch}.deb":
    source => "puppet:///modules/alfred/alfred_${::alfred::version}_${::alfred::params::arch}.deb",
  } ->
  package { 'alfred':
    ensure   => latest, # if this is not here, we wont get an updated package
    provider => 'dpkg',
    source   => "/tmp/alfred_${::alfred::version}_${::alfred::params::arch}.deb",
  }

  package { 'zlib1g':
    ensure => installed,
  } ->
  package { 'libjansson4':
    ensure => installed,
  } ->
  file { "/tmp/alfred-json_${::alfred::alfred_json_version}_${::alfred::params::arch}.deb":
    source => "puppet:///modules/alfred/alfred-json_${::alfred::alfred_json_version}_${::alfred::params::arch}.deb",
  } ->
  package { 'alfred-json':
    ensure   => latest, # if this is not here, we wont get an updated package
    provider => 'dpkg',
    source   => "/tmp/alfred-json_${::alfred::alfred_json_version}_${::alfred::params::arch}.deb",
  }
}
