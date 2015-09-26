class component::collectd (
  $plugins={},
  $plugin_classes=[],
) {
  contain ::collectd

  $merged_plugins = merge(hiera_hash('component::collectd::plugins'), $plugins)
  $merged_plugin_classes = unique(concat(
    hiera_array('component::collectd::plugin_classes'),
    $plugin_classes
  ))

  create_resources(::collectd::plugin, $merged_plugins)

  each($merged_plugin_classes) |$class| {
    contain "::collectd::plugin::${class}"
  }
}
