# vim: set sw=2 sts=2 et tw=80 :
define fastd::server_peer (
  $public_key,
  $fastd_port,
  $contact,
) {

  include ::fastd::params

  validate_re($public_key, '^.{64}$', 'public_key is not 64 characters long!')
  validate_re($contact,
    '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    'contact is not an email address'
    )

  if ! is_integer($fastd_port) {
    fail('fastd_port is not an integer!')
  } elsif ! ($fastd_port > 1024) and ($fastd_port < 65536) {
    fail('fastd_port is not a valid port-number!')
  }

  if ($name != $::fqdn)
    and ($name != $::fastd::connection_ip )
    and ! has_ip_address($name) {

    file {"${::fastd::config_path}/peers/${name}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('fastd/fastd-server-peer.erb'),
      require => [ Package['fastd'], File["${::fastd::config_path}/peers/"] ],
      notify  => Service['fastd'],
    }
  }
}

