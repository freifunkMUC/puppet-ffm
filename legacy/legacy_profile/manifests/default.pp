class profile::default {

  sysctl { 'fs.file-max': value => '100000' }
  sysctl { 'vm.swappiness': value => '10' }

  contain '::chrony'

}
