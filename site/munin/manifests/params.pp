class munin::params {

  case $::operatingsystem {
    'Ubuntu': {
      $node_package = 'munin-node'
      $service = 'munin-node'
    }
    default: {
      notify { "munin is currently not supported for ${::operatingsystem}!": }
    }
  }

}
