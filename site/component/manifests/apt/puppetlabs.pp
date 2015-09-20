class component::apt::puppetlabs (
  $location='http://apt.puppetlabs.com/'
) {
  package { 'puppetlabs-release':
    ensure  => 'purged'
  }

  apt::source { 'puppetlabs':
    location    => $location,
    repos       => 'main',
    key         => '4BD6EC30',
    key_server  => 'keyserver.ubuntu.com',
    include_src => false,
    require     => Package['puppetlabs-release'],
  }
}
