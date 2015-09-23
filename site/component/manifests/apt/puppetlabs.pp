class component::apt::puppetlabs (
  $location='http://apt.puppetlabs.com/'
) {
  Apt::Source {
    include  => {
      deb => true,
      src => false
    },
  }

  package { 'puppetlabs-release':
    ensure  => 'purged',
  }

  apt::source { 'puppetlabs':
    location => $location,
    release  => 'stable',
    repos    => 'main',
    key      => {
      id     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
      server => 'keyserver.ubuntu.com',
    },
    require  => Package['puppetlabs-release'],
  }
}
