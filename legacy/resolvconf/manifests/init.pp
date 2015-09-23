class resolvconf (
  $ensure = 'installed',
  $lo_nameservers = [ '213.73.91.35' ],
) {

  include ::resolvconf::install
  include ::resolvconf::config

}
