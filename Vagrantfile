# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir   = File.dirname(File.expand_path(__FILE__))
configs       = YAML.load_file("#{current_dir}/configs.yaml")

puppet_folder = configs['puppet_folder']
hiera_folder  = puppet_folder + '/' + configs['hiera_folder']

hiera_hosts = Dir.glob(current_dir + '/hieradata/hosts/*.yaml')
  .map { |foo| File.basename(foo, '.yaml') }

ENV['VAGRANT_DEFAULT_PROVIDER'] ||= configs['vagrant_provider']

Vagrant.configure( 2 ) do |config|

  config.vm.define configs['hostname'] do |d|
    d.vm.box = configs['boxname']
    d.vm.hostname = configs['hostname']
    d.vm.synced_folder hiera_folder, configs['hiera_folder_on_guest'], type: 'nfs', :nfs_version => configs['nfs_version'], :nfs_udp => configs['nfs_udp']

    d.vm.provider configs['vagrant_provider'] do |domain|
      domain.memory = configs['memory']
      domain.cpus = 1
    end

    d.vm.provision "puppet" do |puppet|
      puppet.synced_folder_type = "nfs"
      puppet.manifests_path = puppet_folder + "/manifests"
      puppet.manifest_file = "site.pp"
      puppet.module_path = [ puppet_folder + "/site", puppet_folder + "/modules" ]
      puppet.hiera_config_path = puppet_folder + "/hiera.yaml"
      puppet.working_directory = configs['hiera_folder_on_guest']
      puppet.options = configs['puppet_options']
    end
  end

  hiera_hosts.sort.each do |host|
    config.vm.define host do |h|
      h.vm.hostname = host + '.localdomain'

      h.vm.provision "puppet" do |p|
        p.manifests_path = "manifests"
        p.manifest_file = "site.pp"
        p.module_path = [ "site", "modules" ]
        p.hiera_config_path = "hiera.yaml"
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

