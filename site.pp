Exec{
  path => '/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin',
}

node default {
  contain ::role
}
