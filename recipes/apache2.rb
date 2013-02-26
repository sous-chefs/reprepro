#
# Cookbook Name:: reprepro
# Recipe:: apache2
#

include_recipe "build-essential"
include_recipe "apache2"

template "#{node[:apache][:dir]}/sites-available/apt_repo.conf" do
  source "apt_repo.conf.erb"
  mode 0644
  variables(
    :repo_dir => node[:reprepro][:repo_dir]
  )
end

apache_site "apt_repo.conf"

apache_site "000-default" do
  enable false
end
