#
# Author:: Joshua Timberman (<joshua@chef.io>)
# Cookbook Name:: reprepro
# Recipe:: default
#
# Copyright 2010-2018, Chef Software, Inc.
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

build_essential 'compilation tools'

unless node['reprepro']['disable_databag']
  begin
    apt_repo = data_bag_item('reprepro', 'main')
    node['reprepro'].keys.each do |key|
      next if key.to_sym == :pgp
      # NOTE: Use #key? so data bags can nil out existing values
      node.default['reprepro'][key] = apt_repo[key] if apt_repo.key?(key)
    end
    node.default['reprepro']['pgp_email'] = apt_repo['pgp']['email']
    node.default['reprepro']['pgp_fingerprint'] = apt_repo['pgp']['fingerprint']
  rescue Net::HTTPServerException
    Chef::Log.warn 'Data bag not found. Using default attribute settings!'
    include_recipe 'gpg'
  end
end

ruby_block 'save node data' do
  block do
    node.save
  end
  action :run
  not_if { ::Chef::Config[:solo] }
end

package %w(apt-utils dpkg-dev reprepro debian-keyring devscripts dput)

[node['reprepro']['repo_dir'], node['reprepro']['incoming']].each do |dir|
  directory dir do
    owner node['reprepro']['owner']
    group node['reprepro']['group']
    mode node['reprepro']['dirmode']
    recursive true
  end
end

%w(conf db dists pool tarballs).each do |dir|
  directory "#{node['reprepro']['repo_dir']}/#{dir}" do
    owner node['reprepro']['owner']
    group node['reprepro']['group']
    mode node['reprepro']['dirmode']
  end
end

%w(distributions incoming pulls).each do |conf|
  template "#{node['reprepro']['repo_dir']}/conf/#{conf}" do
    source "#{conf}.erb"
    owner node['reprepro']['owner']
    group node['reprepro']['group']
    mode node['reprepro']['filemode']
    variables(
      allow: node['reprepro']['allow'],
      codenames: node['reprepro']['codenames'],
      architectures: node['reprepro']['architectures'],
      incoming: node['reprepro']['incoming'],
      pulls: node['reprepro']['pulls']
    )
  end
end

if apt_repo
  pgp_key = "#{apt_repo['repo_dir']}/#{node['reprepro']['pgp_email']}.gpg.key"

  apt_repo["pgp"]["users"].each do |pgpuser|
    execute "import packaging key for #{pgpuser}" do
      user node['reprepro']['owner']
      command "/bin/echo -e '#{apt_repo["pgp"]["private"]}' | su -l -c \'gpg --import -\' #{pgpuser}"
      not_if "su -l -c \"gpg --list-secret-keys --fingerprint #{apt_repo['pgp']['email']} | egrep -qx '.*Key fingerprint = " + apt_repo['pgp']['fingerprint'] + "'\" #{pgpuser}"
    end
  end

  template pgp_key do
    source "pgp_key.erb"
    owner node['reprepro']['owner']
    group node['reprepro']['group']
    mode node['reprepro']['filemode']
    variables(
      pgp_public: apt_repo['pgp']['public']
    )
  end
else
  pgp_key = "#{node['reprepro']['repo_dir']}/#{node['gpg']['name']['email']}.gpg.key"
  node.default['reprepro']['pgp_email'] = node['gpg']['name']['email']

  execute "su -l -c \'gpg --armor --export #{node['gpg']['name']['real']} > #{pgp_key}\' #{node['gpg']['user']}" do
    creates pgp_key
  end

  file pgp_key do
    owner node['reprepro']['owner']
    group node['reprepro']['group']
    mode node['reprepro']['filemode']
  end

  execute "su -l -c \'reprepro -Vb #{node['reprepro']['repo_dir']} export\' #{node['reprepro']['owner']}" do
    action :nothing
    subscribes :run, "file[#{pgp_key}]", :immediately
    environment 'GNUPGHOME' => node['reprepro']['gnupg_home']
    not_if "reprepro -Vb #{node['reprepro']['repo_dir']} check"
  end
end

if node['reprepro']['enable_repository_on_host']
  execute "apt-key add #{pgp_key}" do
    action :nothing
    if apt_repo
      subscribes :run, "template[#{pgp_key}]", :immediately
    else
      subscribes :run, "file[#{pgp_key}]", :immediately
    end
  end

  apt_repository 'reprepro' do
    uri "file://#{node['reprepro']['repo_dir']}"
    distribution node['lsb']['codename']
    components ['main']
  end
end

begin
  include_recipe "reprepro::#{node['reprepro']['server']}"
rescue Chef::Exceptions::RecipeNotFound
  Chef::Log.warn "Missing recipe for #{node['reprepro']['server']}, only 'nginx'or 'apache2' are available"
end
