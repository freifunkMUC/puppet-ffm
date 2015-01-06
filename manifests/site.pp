Exec{
  path => '/usr/sbin:/usr/bin:/sbin:/bin',
}

node default {
  hiera_include('classes')
}

