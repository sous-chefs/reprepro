# frozen_string_literal: true

provides :reprepro_nginx
unified_mode true

property :site_name, String,
         name_property: true,
         description: 'Nginx site name'

property :repo_dir, String,
         default: '/srv/apt',
         description: 'Repository document root'

property :fqdn, String,
         default: lazy { node['fqdn'] },
         description: 'server_name for the repository virtual host'

property :listen_port, Integer,
         default: 80,
         description: 'HTTP listen port'

property :ssl, [true, false],
         default: false,
         description: 'Enable HTTPS listener'

property :ssl_certificate, [String, nil],
         description: 'Path to the SSL certificate for HTTPS'

property :ssl_certificate_key, [String, nil],
         description: 'Path to the SSL certificate key for HTTPS'

default_action :create

action :create do
  nginx_install 'nginx' do
    source 'distro'
  end

  nginx_config 'nginx' do
    default_site_enabled false
    notifies :reload, 'nginx_service[nginx]', :delayed
  end

  nginx_site new_resource.site_name do
    cookbook 'reprepro'
    template 'apt_repo.nginx.erb'
    variables(
      fqdn: new_resource.fqdn,
      listen_port: new_resource.listen_port,
      repo_dir: new_resource.repo_dir,
      ssl: new_resource.ssl,
      ssl_certificate: new_resource.ssl_certificate,
      ssl_certificate_key: new_resource.ssl_certificate_key
    )
    notifies :reload, 'nginx_service[nginx]', :delayed
  end

  nginx_service 'nginx' do
    action [:enable, :start]
  end
end

action :delete do
  nginx_service 'nginx' do
    action :nothing
  end

  nginx_site new_resource.site_name do
    action :delete
    notifies :reload, 'nginx_service[nginx]', :delayed
  end
end
