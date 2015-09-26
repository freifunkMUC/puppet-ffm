class profile::default (
  $includes = [],
  $components = [],
) {
  each($includes) |$include| {
    include "::${include}"
  }

  each($components) |$component| {
    contain "::component::${component}"
  }
}
