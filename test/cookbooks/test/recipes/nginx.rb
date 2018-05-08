apt_update

node.default['reprepro']['server'] = 'nginx'

include_recipe 'reprepro::default'
