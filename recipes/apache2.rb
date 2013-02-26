#
# Cookbook Name:: reprepro
# Recipe:: apache2
#

include_recipe "build-essential"
include_recipe "apache2"

apache_site "apt_repo.conf"

apache_site "000-default" do
  enable false
end
