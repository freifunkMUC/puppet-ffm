class component::fail2ban {
  class { '::fail2ban':
    config_file_template => "fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
  }
}
