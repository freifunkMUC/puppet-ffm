class component::apt (
  $repos  = [],
  $pins   = {}
) {
  contain '::apt'
  contain '::apt::update'

  $os = downcase($::operatingsystem)
  contain "component::apt::${os}"

  package { 'apt-transport-https': ensure => present }

  each($repos) |$repo| {
    contain "::component::apt::${repo}"
  }

  create_resources('apt::pin', $pins)
}
