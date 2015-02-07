class openvpn (
  $configs = {},
  $ensure = 'installed',
) {

  include ::openvpn::install
  include ::openvpn::service

  create_resources( ::openvpn::provider, $configs )

}
