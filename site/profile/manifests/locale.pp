class profile::locale (
  $default='en_US.UTF-8',
) {
  augeas { 'default-locale':
    context => '/files/etc/default/locale',
    changes => "set LANG ${default}",
  }
}
