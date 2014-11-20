class profiles::apt {

  contain ::apt

  apt::source { 'universe-factory':
    location => 'http://repo.universe-factory.net/debian/',
    release => 'sid',
    repos => 'main',
    key => 'AB7A88C5B89033D8',
    key_server => 'subkeys.pgp.net',
    include_src => false,
  }

}
