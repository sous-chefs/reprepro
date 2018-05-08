property :package, String, name_property: true
property :distribution, [String, Array], default: lazy { node['lsb']['codename'] }

action :add do
  p_name = `dpkg-deb -f #{new_resource.package} package`.strip
  p_version = `dpkg-deb -f #{new_resource.package} version`.strip

  execute "Add deb package (#{::File.basename(new_resource.package)})" do
    command "reprepro -Vb #{node['reprepro']['repo_dir']} includedeb #{new_resource.distribution} #{new_resource.package}"
    cwd ::File.dirname(new_resource.package)
    environment 'GNUPGHOME' => node['reprepro']['gnupg_home']
    not_if do
      ex = `reprepro -b #{node['reprepro']['repo_dir']} list #{new_resource.distribution} #{p_name}`
      ex.to_s.strip.split(' ').last == p_version
    end
  end
end

action :remove do
  p_name = if ::File.exist?(new_resource.package)
             `dpkg-deb -f #{new_resource.package} package`.strip
           else
             ::File.basename(new_resource.package.sub('.deb', ''))
           end

  execute "Remove package (#{::File.basename(new_resource.package)})" do
    command "reprepro -Vb #{node['reprepro']['repo_dir']} remove #{new_resource.distribution} #{p_name}"
    environment 'GNUPGHOME' => node['reprepro']['gnupg_home']
    not_if do
      `reprepro -b #{node['reprepro']['repo_dir']} list #{new_resource.distribution} #{p_name}`.empty?
    end
  end
end
