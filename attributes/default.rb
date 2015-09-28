#
# Cookbook Name:: reprepro
# Attributes:: default
#
# Copyright 2009-2015, Chef Software, Inc.
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

default['reprepro']['fqdn'] = node['fqdn']
default['reprepro']['listen_port'] = 80
default['reprepro']['repo_dir'] = '/srv/apt'
default['reprepro']['incoming'] = '/srv/apt_incoming'
default['reprepro']['description'] = "APT repository at #{node['fqdn']}"
default['reprepro']['codenames'] = [node['lsb']['codename']]
default['reprepro']['allow'] = []
default['reprepro']['pulls']['name'] = node['lsb']['codename']
default['reprepro']['pulls']['from'] = node['lsb']['codename']
default['reprepro']['pulls']['component'] = 'main'
default['reprepro']['architectures'] = %w(i386 amd64)
default['reprepro']['gnupg_home'] = '/root/.gnupg'
default['reprepro']['enable_repository_on_host'] = false
default['reprepro']['disable_databag'] = false

default['reprepro']['nginx']['listen_port'] = 80
default['reprepro']['nginx']['ssl'] = false
default['reprepro']['nginx']['ssl_certificate'] = "#{node['nginx']['dir']}/ssl/#{node['reprepro']['fqdn']}.crt"
default['reprepro']['nginx']['ssl_certificate_key'] = "#{node['nginx']['dir']}/ssl/#{node['reprepro']['fqdn']}.key"

default['reprepro']['server'] = 'apache'
