class profile::apt {

  include ::apt

  Exec['apt_update'] -> Package <||>

  ::apt::source { 'universe-factory':
    comment     => 'universe-factory repository for Freifunk',
    location    => 'http://repo.universe-factory.net/debian/',
    release     => 'sid',
    repos       => 'main',
    key         => '16EF3F64CB201D9C',
    key_server  => 'pool.sks-keyservers.net',
    include_src => false,
    include_deb => true
  }

  if $::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '14.04' {
    ::apt::pin { 'batman':
      packages        => '*',
      priority        => 1000,
      release_version => '14.04',
      label           => 'Ubuntu',
    } ->

    ::apt::source { 'utopic':
      comment     => 'ubuntu utopic',
      #location    => 'http://de.archive.ubuntu.com/ubuntu/',
      location    => 'http://archive.ubuntu.com/ubuntu/',
      release     => 'utopic',
      repos       => 'main universe',
      include_src => true,
      include_deb => true
    }

    ::apt::source { 'vivid':
      comment     => 'ubuntu vivid',
      #location    => 'http://de.archive.ubuntu.com/ubuntu/',
      location    => 'http://archive.ubuntu.com/ubuntu/',
      release     => 'vivid',
      repos       => 'main universe',
      include_src => true,
      include_deb => true
    }
  }

}
