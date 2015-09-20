class component::apt::freifunk {
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

  ::apt::source { 'ffmuc':
    location    => 'http://apt.ffmuc.bpletza.de/',
    release     => 'trusty',
    repos       => 'main',
    key         => '64EEAB18',
    key_server  => 'keys.gnupg.net',
    include_src => false
  }
}
