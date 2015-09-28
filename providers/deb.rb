def load_current_resource
  new_resource.package new_resource.name unless new_resource.package
  new_resource.distribution node['lsb']['codename'] unless new_resource.distribution
end

action :add do
  p_name = `dpkg-deb -f #{new_resource.package} package`.strip
  p_version = `dpkg-deb -f #{new_resource.package} version`.strip
  e = execute "Add deb package (#{::File.basename(new_resource.package)})" do
    command "reprepro -Vb #{node['reprepro']['repo_dir']} includedeb #{new_resource.distribution} #{new_resource.package}"
    cwd ::File.dirname(new_resource.package)
    environment 'GNUPGHOME' => node['reprepro']['gnupg_home']
    not_if do
      ex = `reprepro -b #{node['reprepro']['repo_dir']} list #{new_resource.distribution} #{p_name}`
      ex.to_s.strip.split(' ').last == p_version
    end
  end
  new_resource.updated_by_last_action(e.updated_by_last_action?)
end

action :remove do
  if ::File.exist?(new_resource.package)
    p_name = `dpkg-deb -f #{new_resource.package} package`.strip
  else
    p_name = ::File.basename(new_resource.package.sub('.deb', ''))
  end
  e = execute "Remove package (#{::File.basename(new_resource.package)})" do
    command "reprepro -Vb #{node['reprepro']['repo_dir']} remove #{new_resource.distribution} #{p_name}"
    environment 'GNUPGHOME' => node['reprepro']['gnupg_home']
    not_if do
      `reprepro -b #{node['reprepro']['repo_dir']} list #{new_resource.distribution} #{p_name}`.empty?
    end
  end
  new_resource.updated_by_last_action(e.updated_by_last_action?)
end
