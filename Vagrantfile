Vagrant.configure('2') do |config|
  config.vm.box = 'mayflower/trusty64-puppet3'
  
  config.vm.provision :puppet,
    module_path: [ 'modules' ],
    manifests_path: '.',
    manifest_file: 'site.pp',
    options: '--verbose',
    hiera_config_path: 'hiera.yaml'

end
