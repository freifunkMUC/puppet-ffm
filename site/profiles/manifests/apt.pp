class profiles::apt {

  include ::apt

  ::apt::source { 'universe-factory':
    comment           => 'universe-factory repository for Freifunk',
    location          => 'http://repo.universe-factory.net/debian/',
    release           => 'sid',
    repos             => 'main',
    key               => '16EF3F64CB201D9C',
    key_server        => 'pgp.mit.edu',
    include_src       => false,
    include_deb       => true
  }

}
