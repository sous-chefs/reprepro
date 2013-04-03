
node.set['apache']['listen_ports'] = node['apache']['listen_ports'] | Array(node['reprepro']['listen_port'])

include_recipe "apache2"

template "#{node['apache']['dir']}/sites-available/apt_repo.conf" do
  source "apt_repo.conf.erb"
  mode 0644
  variables(
      :repo_dir => node['reprepro']['repo_dir']
  )
end

apache_site "apt_repo.conf"

apache_site "000-default" do
  enable false
end

