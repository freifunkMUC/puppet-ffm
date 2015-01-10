require 'puppet-lint/tasks/puppet-lint'

Rake::Task['lint'].clear

PuppetLint::RakeTask.new :lint do |config|
  config.pattern = ['manifests/**/*.pp', 'site/**/*.pp']
end

PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')

require 'puppet-syntax/tasks/puppet-syntax'
PuppetSyntax.exclude_paths ||= []
PuppetSyntax.exclude_paths << "spec/fixtures/**/*"
PuppetSyntax.exclude_paths << "vendor/**/*"
PuppetSyntax.future_parser = false

task :validate do
  Rake::Task[:syntax].invoke
end

task :default => [:validate, :lint]
