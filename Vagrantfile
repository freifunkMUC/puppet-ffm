# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir   = File.dirname(File.expand_path(__FILE__))
configs       = YAML.load_file("#{current_dir}/configs.yaml")

puppet_folder = configs['puppet_folder']
hiera_folder  = puppet_folder + '/' + configs['hiera_folder']

hiera_hosts = Dir.glob(current_dir + '/hieradata/hosts/*.yaml')
  .map { |host_path| File.basename(host_path, '.yaml') }

ENV['VAGRANT_DEFAULT_PROVIDER'] ||= configs['vagrant_provider']

Vagrant.configure( 2 ) do |config|

  hiera_hosts.sort.each do |host|
    config.vm.define host do |h|
      if configs['boxname']
        h.vm.box = configs['boxname']

        h.vm.provider configs['vagrant_provider'] do |domain|
          domain.memory = configs['memory']
          domain.cpus = 1
        end
      end

      h.vm.hostname = host + '.localdomain'

      h.vm.provision "puppet" do |p|
        p.synced_folder_type = "nfs"
        p.manifests_path = "manifests"
        p.manifest_file = "site.pp"
        p.module_path = [ "site", "modules" ]
        p.hiera_config_path = "hiera.yaml"
        #p.hiera_datadir_path = "hieradata" # only with patch for puppet-provider available
        p.working_directory = "/vagrant"
        p.options = configs['puppet_options']
      end
    end
  end

  config.vm.provider 'docker' do |d|
    d.image = 'ffmuc/vagrant'
    d.has_ssh = true
  end
end

