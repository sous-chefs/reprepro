#
# Cookbook Name:: reprepro
# Recipe:: nginx
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

# The recipe does not assume how you install nginx certificate if you use ssl

include_recipe 'nginx'

template "#{node['nginx']['dir']}/sites-available/apt_repo" do
  source 'apt_repo.nginx.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    repo_dir: node['reprepro']['repo_dir']
  )
  notifies :reload, 'service[nginx]'
end

nginx_site 'apt_repo'

nginx_site 'default' do
  action :disable
end
