source 'https://rubygems.org'

gem 'librarian-puppet'

group :development do
  gem 'rake'
  gem 'rspec-puppet'
  gem 'puppetlabs_spec_helper'
  gem 'puppet-lint'
  gem 'r10k'

  if facterversion = ENV['FACTER_GEM_VERSION']
    gem 'facter', facterversion
  else
    gem 'facter'
  end

  if puppetversion = ENV['PUPPET_GEM_VERSION']
    gem 'puppet', puppetversion
  else
    gem 'puppet'
  end
end
