# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

configs = {
  'boxname'          => 'mayflower/trusty64-puppet3',
  'memory'           => 1024,
  'puppet_options'   => if ENV['VAGRANT_PUPPET_DEBUG'] == '1' then '--debug' else '' end,
  'vagrant_provider' => ENV['VAGRANT_DEFAULT_PROVIDER'] || 'virtualbox',
  'nfs'              => false,
}

current_dir   = File.dirname(File.expand_path(__FILE__))
config_file   = "#{current_dir}/.config.yaml"
configs       = configs.merge(YAML.load_file(config_file)) if File.exist?(config_file)

hiera_hosts = Dir.glob(current_dir + '/hieradata/hosts/*.yaml')
  .map { |host_path| File.basename(host_path, '.yaml') }


Vagrant.configure(2) do |config|

  hiera_hosts.sort.each_with_index do |host, index|
    config.vm.define host do |h|
      if configs['boxname']
        h.vm.box = configs['boxname']

        if !['lxc'].include?(configs['vagrant_provider']) then
          h.vm.provider configs['vagrant_provider'] do |domain|
            domain.memory = configs['memory']
            domain.cpus = 1
          end
        end

        h.vm.synced_folder 'hieradata', '/vagrant/hieradata', :nfs => configs['nfs']
      end

      h.vm.hostname = host + '.localdomain'

      h.vm.provision "puppet" do |p|
        p.synced_folder_type = "nfs" if configs['nfs']
        p.manifests_path = "."
        p.manifest_file = "site.pp"
        p.module_path = [ "legacy", "site", "modules" ]
        p.hiera_config_path = "hiera.yaml"
        p.working_directory = "/vagrant"
        p.options = [ '--parser=future', configs['puppet_options']].join(' ')
      end
    end
  end

  if configs['vagrant_provider'] == 'docker' then
    config.vm.provider 'docker' do |d|
      d.image = 'ffmuc/vagrant'
      d.has_ssh = true
    end
  end
end
