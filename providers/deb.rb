def load_current_resource
  unless(new_resource.package)
    new_resource.package new_resource.name
  end
  unless(new_resource.distribution)
    new_resource.distribution node['lsb']['codename']
  end
end

action :add do
  p_name = %x{dpkg-deb -f #{new_resource.package} package}.strip
  p_version = %x{dpkg-deb -f #{new_resource.package} version}.strip
  e = execute "Add deb package (#{::File.basename(new_resource.package)})" do
    command "reprepro -Vb #{node['reprepro']['repo_dir']} includedeb #{new_resource.distribution} #{new_resource.package}"
    cwd ::File.dirname(new_resource.package)
    environment "GNUPGHOME" => node['reprepro']['gnupg_home']
    not_if do
      ex = %x{reprepro -b #{node['reprepro']['repo_dir']} list #{new_resource.distribution} #{p_name}}
      ex.to_s.strip.split(' ').last == p_version
    end
  end
  new_resource.updated_by_last_action(e.updated_by_last_action?)
end

action :remove do
  if(::File.exists?(new_resource.package))
    p_name = %x{dpkg-deb -f #{new_resource.package} package}.strip
  else
    p_name = ::File.basename(new_resource.package.sub('.deb', ''))
  end
  e = execute "Remove package (#{::File.basename(new_resource.package)})" do
    command "reprepro -Vb #{node['reprepro']['repo_dir']} remove #{new_resource.distribution} #{p_name}"
    environment "GNUPGHOME" => node['reprepro']['gnupg_home']
    not_if do
      %x{reprepro -b #{node['reprepro']['repo_dir']} list #{new_resource.distribution} #{p_name}}.empty?
    end
  end
  new_resource.updated_by_last_action(e.updated_by_last_action?)
end
