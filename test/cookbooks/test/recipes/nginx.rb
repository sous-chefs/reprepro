apt_update 'update'

default['reprepro']['server'] = 'nginx'

include_recipe 'reprepro::default'
