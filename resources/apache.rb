# frozen_string_literal: true

provides :reprepro_apache
unified_mode true

property :site_name, String,
         name_property: true,
         description: 'Apache site name'

property :repo_dir, String,
         default: '/srv/apt',
         description: 'Repository document root'

property :fqdn, String,
         default: lazy { node['fqdn'] },
         description: 'ServerName for the repository virtual host'

property :server_aliases, Array,
         default: lazy { [node['hostname'], node['fqdn']] },
         description: 'ServerAlias values for the repository virtual host'

property :pgp_email, [String, nil],
         description: 'ServerAdmin value for the repository virtual host'

property :listen_port, Integer,
         default: 80,
         description: 'HTTP listen port'

default_action :create

action :create do
  apache2_install 'default' do
    listen [new_resource.listen_port.to_s]
  end

  apache2_service 'default' do
    action [:enable, :start]
  end

  template "#{new_resource.site_name}.conf" do
    source 'apt_repo.conf.erb'
    path "/etc/apache2/sites-available/#{new_resource.site_name}.conf"
    cookbook 'reprepro'
    mode '0644'
    variables(
      fqdn: new_resource.fqdn,
      listen_port: new_resource.listen_port,
      pgp_email: new_resource.pgp_email || "root@#{new_resource.fqdn}",
      repo_dir: new_resource.repo_dir,
      server_aliases: new_resource.server_aliases
    )
    notifies :reload, 'apache2_service[default]', :delayed
  end

  apache2_site new_resource.site_name

  apache2_site '000-default' do
    action :disable
  end
end

action :delete do
  apache2_service 'default' do
    action :nothing
  end

  apache2_site new_resource.site_name do
    action :disable
  end

  file "/etc/apache2/sites-available/#{new_resource.site_name}.conf" do
    action :delete
    notifies :reload, 'apache2_service[default]', :delayed
  end
end
