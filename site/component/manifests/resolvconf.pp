class component::resolvconf (
  $nameservers,
  $enabled      = true,
  $domain       = $::domain,
  $template     = hiera('component::resolvconf::template')
) {
  if $enabled {
    package { 'resolvconf':
      ensure => absent
    } ->

    file { '/etc/dhcp/dhclient-enter-hooks.d/nodnsupdate':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => join([
        "make_resolv_conf() {",
        "    :",
        "}"
      ], "\n")
    } ->

    file { '/etc/resolv.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0744',
      content => inline_template($template)
    }
  }
}
