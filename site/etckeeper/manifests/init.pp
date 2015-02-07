class etckeeper (
  $ensure = 'installed'
) {

  include ::etckeeper::install
  include ::etckeeper::config
  include ::etckeeper::setup

}
