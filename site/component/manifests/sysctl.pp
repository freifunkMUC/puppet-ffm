class component::sysctl (
  $settings = {}
){
  create_resources('sysctl::value', $settings)
}
