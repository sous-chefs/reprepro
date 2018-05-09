apt_update

package 'apt-transport-https' if platform_family?('debian')

include_recipe 'reprepro::default'
