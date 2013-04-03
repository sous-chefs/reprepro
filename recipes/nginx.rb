
# The recipe does not assume how you install your certificate if you use them, do that in a proprietary recipe

template "#{node[:nginx][:dir]}/sites-available/apt_repo" do
  source "apt_repo.nginx.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
      :repo_dir => node['reprepro']['repo_dir']
  )
  notifies :reload, resources(:service => 'nginx')
end

nginx_site "apt_repo"

nginx_site "000-default" do
  enable false
end
