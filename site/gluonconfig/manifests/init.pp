class gluonconfig {

# # we should generate some parts of the configs automatically
# # in the future we will manage that with puppetdb
# file { '/root/gluon/site/site.mk':
#   ensure  => file,
#   owner   => 'root',
#   group   => 'root',
#   content => template('testgateway/site.mk.erb'),
# }
# file { '/root/gluon/site/site.conf':
#   ensure  => file,
#   owner   => 'root',
#   group   => 'root',
#   content => template('testgateway/site.conf.erb'),
# }

}
