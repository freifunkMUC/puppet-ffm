Vagrant.configure('2') do |config|
  config.vm.box = 'mayflower/trusty64-puppet3'
  
  config.vm.provision :puppet,
    module_path: [ 'site', 'modules' ],
    manifests_path: '.',
    manifest_file: 'site.pp',
    options: '--verbose --debug',
    hiera_config_path: 'hiera.yaml'

end
