class component::apt::freifunk {
  ::apt::source { 'universe-factory':
    comment  => 'universe-factory repository for Freifunk',
    location => 'http://repo.universe-factory.net/debian/',
    release  => 'sid',
    repos    => 'main',
    key      => { 'id' => '6664E7BDA6B669881EC52E7516EF3F64CB201D9C', 'server' => 'pool.sks-keyservers.net' },
    include  => { 'deb' => true, 'src' => false },
  }

  ::apt::source { 'ffmuc':
    location => 'http://apt.ffmuc.bpletza.de/',
    release  => 'trusty',
    repos    => 'main',
    key      => { 'id' => '7DB926FD6D5625C53E7E17375786E0CF64EEAB18', 'server' => 'keys.gnupg.net' },
    include  => { 'deb' => true, 'src' => false },
  }
}
