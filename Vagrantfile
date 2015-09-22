# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

cfg = {
  'boxname'          => 'debian/jessie64', #'mayflower/trusty64-puppet3',
  'memory'           => 1024,
  'cpus'             => 1,
  'puppet_options'   => if ENV['VAGRANT_PUPPET_DEBUG'] == '1' then '--debug' else '' end,
  'vagrant_provider' => ENV['VAGRANT_DEFAULT_PROVIDER'] || 'virtualbox',
  'nfs'              => false,
}

current_dir = File.dirname(File.expand_path(__FILE__))
config_file = "#{current_dir}/.config.yaml"
cfg = cfg.merge(YAML.load_file(config_file)) if File.exist?(config_file)

hiera_hosts = Dir.glob(current_dir + '/hieradata/hosts/*.yaml')
  .map { |host_path| File.basename(host_path, '.yaml') }

Vagrant.configure(2) do |config|
  config.vm.box = cfg['boxname']

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.provider :virtualbox do |domain|
    domain.memory = cfg['memory']
    domain.cpus = cfg['cpus']
  end

  config.vm.provision "shell", path: 'scripts/bootstrap_puppetdeps.sh'

  config.vm.provision :puppet do |p|
    p.synced_folder_type = "nfs" if cfg['nfs']
    p.manifests_path = "."
    p.manifest_file = "site.pp"
    p.module_path = [ "legacy", "site", "modules" ]
    p.hiera_config_path = "hiera.yaml"
    p.working_directory = "/vagrant"
    p.options = [ '--parser=future', '--verbose', cfg['puppet_options'] ].join(' ')
  end

  hiera_hosts.sort.each_with_index do |host, index|
    config.vm.define host do |h|
      h.vm.hostname = host + '.localdomain'
    end
  end
end
