#
# Cookbook Name:: reprepro
# Recipe:: apache
#
# Author:: Gilles Devaux <gilles.devaux@gmail.com>
# Copyright 2013, Kwarter
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.set['apache']['listen_ports'] = node['apache']['listen_ports'] | Array(node['reprepro']['listen_port'])

include_recipe "apache2"

template "#{node['apache']['dir']}/sites-available/apt_repo.conf" do
  source "apt_repo.conf.erb"
  mode 0644
  variables(
    :repo_dir => node['reprepro']['repo_dir']
  )
end

apache_site "apt_repo" do
  notifies :reload, "service[apache2]", :delayed
end

apache_site "000-default" do
  enable false
  notifies :reload, "service[apache2]", :delayed
end

service "apache2" do
  supports [:reload, :restart, :start, :stop, :status]
  action [:enable, :start]
  case node["platform"]
  when "centos","redhat","fedora"
    service_name "httpd"
  else
    service_name "apache2"
  end
end
