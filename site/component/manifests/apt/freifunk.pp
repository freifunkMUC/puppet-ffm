class component::apt::freifunk {
  Apt::Source {
    include  => {
      deb => true,
      src => false
    },
  }

  ::apt::source { 'ffmuc':
    location => 'http://apt.ffmuc.bpletza.de/',
    release  => 'trusty',
    repos    => 'main',
    key      => {
      id     => '7DB926FD6D5625C53E7E17375786E0CF64EEAB18',
      server => 'keys.gnupg.net',
    },
  }
}
