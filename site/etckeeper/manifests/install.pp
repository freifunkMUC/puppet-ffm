class etckeeper::install {
  include ::package::git

  Package['git'] ->
  package { 'etckeeper':
    ensure => $::etckeeper::ensure,
  }

}
