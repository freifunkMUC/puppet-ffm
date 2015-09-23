class component::fastd (
  $instances,
  $defaults={},
) {
  validate_hash($instances)

  create_resources('::fastd', $instances, $defaults)
}
