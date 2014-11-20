if ($osfamily != 'Debian') {
  fail('Your operating system is not supported!')
}

node default { 
  hiera_include('role')
}
