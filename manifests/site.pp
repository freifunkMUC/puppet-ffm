Exec{
  path => '/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin',
}

node default {
  hiera_include('classes')
}

