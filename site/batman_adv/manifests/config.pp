class batman_adv::config {

  $hex_gateway_number = inline_template("<%= ${::batman_adv::gateway_number}.to_i.to_s(16) -%>")

  if $::osfamily != 'Debian' {
    fail('Only Debian is supported right now.')
  }

  file { '/etc/network/interfaces.d/':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->
  file { '/etc/network/interfaces.d/batman.cfg':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('batman_adv/batman.cfg.erb'),
  }

  exec { "/sbin/ifup ${::batman_adv::bridge}":
    unless  => "/sbin/ifconfig | grep ${::batman_adv::bridge}",
    require => [ Package['bridge-utils'], File['/etc/network/interfaces.d/batman.cfg'] ],
  }

  # source may include any filenames
  # files for source-directory need to match ^[a-zA-Z0-9_-]+$
  # for this reason, the following snippet is correct
  augeas { 'source batman.cfg':
    context => '/files/etc/network/interfaces',
    changes => 'set source[last()+1] interfaces.d/batman.cfg',
    onlyif  => "match source[. = 'interfaces.d/batman.cfg'] size == 0",
    incl    => '/etc/network/interfaces',
    lens    => 'Interfaces.lns',
  }

  File['/etc/network/interfaces.d/batman.cfg'] -> Augeas['source batman.cfg']
  Augeas['source batman.cfg'] -> Exec["/sbin/ifup ${::batman_adv::bridge}"]
}
