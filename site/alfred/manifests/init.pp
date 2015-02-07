class alfred (
  $alfred_json_version = '0.3.1-1',
  $version,
) {

  include ::alfred::params
  include ::alfred::install

}
