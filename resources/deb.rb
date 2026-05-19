# frozen_string_literal: true

provides :reprepro_deb
unified_mode true

property :package, String,
         name_property: true,
         description: 'Path to the .deb package to add or remove'

property :package_name, [String, nil],
         description: 'Package name to remove when the .deb file is not present. Defaults to the .deb basename.'

property :distribution, [String, Array],
         default: lazy { node['lsb']['codename'] },
         description: 'Distribution codename or codenames to modify'

property :repo_dir, String,
         default: '/srv/apt',
         description: 'Root directory of the reprepro repository'

property :gnupg_home, String,
         default: '/root/.gnupg',
         description: 'GNUPG home used by reprepro'

action_class do
  def escaped(value)
    value.to_s.gsub("'", "'\"'\"'")
  end

  def distributions
    Array(new_resource.distribution)
  end

  def package_name
    new_resource.package_name || ::File.basename(new_resource.package, '.deb')
  end
end

action :add do
  distributions.each do |dist|
    execute "Add deb package #{::File.basename(new_resource.package)} to #{dist}" do
      command "reprepro -Vb '#{escaped(new_resource.repo_dir)}' includedeb '#{escaped(dist)}' '#{escaped(new_resource.package)}'"
      cwd ::File.dirname(new_resource.package)
      environment 'GNUPGHOME' => new_resource.gnupg_home
      not_if "test -f '#{escaped(new_resource.package)}' && test \"$(reprepro -b '#{escaped(new_resource.repo_dir)}' list '#{escaped(dist)}' $(dpkg-deb -f '#{escaped(new_resource.package)}' package) | awk '{ print $3 }')\" = \"$(dpkg-deb -f '#{escaped(new_resource.package)}' version)\""
    end
  end
end

action :remove do
  distributions.each do |dist|
    execute "Remove package #{package_name} from #{dist}" do
      command "reprepro -Vb '#{escaped(new_resource.repo_dir)}' remove '#{escaped(dist)}' '#{escaped(package_name)}'"
      environment 'GNUPGHOME' => new_resource.gnupg_home
      only_if "reprepro -b '#{escaped(new_resource.repo_dir)}' list '#{escaped(dist)}' '#{escaped(package_name)}' | grep -q ."
    end
  end
end
