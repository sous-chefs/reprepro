apt_update

package 'apt-transport-https' if platform_family?('debian')
# Set for testing purposes
node.default['nginx']['dir'] = '/etc/nginx'

include_recipe 'reprepro::default'
