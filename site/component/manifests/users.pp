class component::users (
  $collections=[],
) {
  $all_collections = unique(flatten(
    [ $collections, hiera_array('component::users::collections', []) ]
  ))

  component::users::collection { $all_collections: }
}
