# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir    = File.dirname(File.expand_path(__FILE__))
configs        = YAML.load_file("#{current_dir}/configs.yaml")

puppet_folder  = configs['puppet_folder']



ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'libvirt'

Vagrant.configure( 2 ) do |config|
  config.vm.provision "shell", :inline => <<-SHELL
    apt-get update
    apt-get install -y puppet
  SHELL

  config.vm.define configs['gw_hostname'] do |boxname|
    boxname.vm.box = 'trino/debianjessie'
    boxname.vm.hostname = configs['gw_hostname']
    boxname.vm.synced_folder '/opt/puppet/hiera/', '/tmp/hiera', type: 'nfs'
    boxname.vm.network :private_network, :ip => "192.168.100." + configs['gw_num']
  end

  config.vm.provider :libvirt do |domain|
    domain.memory = 1024
    domain.cpus = 1
  end

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = puppet_folder + "/manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = [ puppet_folder + "/site", puppet_folder + "/modules" ]
    puppet.hiera_config_path = puppet_folder + "/hiera.yaml"
    puppet.working_directory = "/tmp/hiera"
    puppet.options = "--verbose --debug"
  end

end

