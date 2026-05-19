# frozen_string_literal: true

provides :reprepro_repository
unified_mode true

property :repo_name, String,
         name_property: true,
         description: 'Repository instance name'

property :fqdn, String,
         default: lazy { node['fqdn'] },
         description: 'FQDN advertised in repository metadata and web server config'

property :description, String,
         default: lazy { "APT repository at #{fqdn}" },
         description: 'Repository description written to conf/distributions'

property :repo_dir, String,
         default: '/srv/apt',
         description: 'Root directory for the reprepro repository'

property :incoming, String,
         default: '/srv/apt_incoming',
         description: 'Incoming package directory'

property :codenames, Array,
         default: lazy { [node['lsb']['codename']] },
         description: 'Distribution codenames to configure'

property :allow, Array,
         default: [],
         description: 'Additional incoming Allow entries'

property :pulls, Hash,
         default: lazy { { 'name' => node['lsb']['codename'], 'from' => node['lsb']['codename'], 'component' => 'main' } },
         description: 'Pull configuration written to conf/pulls'

property :architectures, Array,
         default: %w(i386 amd64),
         description: 'Architectures written to conf/distributions'

property :gnupg_home, String,
         default: '/root/.gnupg',
         description: 'GNUPG home used when importing or exporting signing keys'

property :pgp_email, [String, nil],
         description: 'Signing key email. When nil, SignWith is omitted from distributions.'

property :pgp_fingerprint, [String, nil],
         description: 'Expected PGP key fingerprint used to guard private key imports'

property :pgp_public, [String, nil],
         sensitive: true,
         description: 'ASCII-armored public PGP key to publish in the repository root'

property :pgp_private, [String, nil],
         sensitive: true,
         description: 'ASCII-armored private PGP key to import for repository signing'

property :repo_owner, String,
         default: 'nobody',
         description: 'Owner for repository files and directories'

property :repo_group, String,
         default: 'nogroup',
         description: 'Group for repository files and directories'

property :packages, Array,
         default: %w(apt-utils dpkg-dev reprepro debian-keyring devscripts dput),
         description: 'Packages required to manage the repository'

property :install_build_tools, [true, false],
         default: true,
         description: 'Install build-essential tooling before reprepro packages'

property :enable_repository_on_host, [true, false],
         default: false,
         description: 'Configure the local host to consume the generated repository'

property :local_repository_components, Array,
         default: ['main'],
         description: 'APT components for the local repository entry'

default_action :create

action_class do
  def pgp_key_path
    return unless new_resource.pgp_email

    ::File.join(new_resource.repo_dir, "#{new_resource.pgp_email}.gpg.key")
  end

  def key_guard
    return "GNUPGHOME=#{new_resource.gnupg_home} gpg --list-secret-keys #{new_resource.pgp_email}" unless new_resource.pgp_fingerprint

    "GNUPGHOME=#{new_resource.gnupg_home} gpg --list-secret-keys --fingerprint #{new_resource.pgp_email} | grep -q '#{new_resource.pgp_fingerprint}'"
  end
end

action :create do
  build_essential 'compilation tools' if new_resource.install_build_tools

  package new_resource.packages

  [new_resource.repo_dir, new_resource.incoming].each do |dir|
    directory dir do
      owner new_resource.repo_owner
      group new_resource.repo_group
      mode '0755'
      recursive true
    end
  end

  %w(conf db dists pool tarballs).each do |dir|
    directory ::File.join(new_resource.repo_dir, dir) do
      owner new_resource.repo_owner
      group new_resource.repo_group
      mode '0755'
    end
  end

  %w(distributions incoming pulls).each do |conf|
    template ::File.join(new_resource.repo_dir, 'conf', conf) do
      source "#{conf}.erb"
      cookbook 'reprepro'
      mode '0644'
      owner new_resource.repo_owner
      group new_resource.repo_group
      variables(
        allow: new_resource.allow,
        architectures: new_resource.architectures,
        codenames: new_resource.codenames,
        description: new_resource.description,
        fqdn: new_resource.fqdn,
        incoming: new_resource.incoming,
        pgp_email: new_resource.pgp_email,
        pulls: new_resource.pulls
      )
    end
  end

  if new_resource.pgp_private
    directory new_resource.gnupg_home do
      owner 'root'
      group 'root'
      mode '0700'
      recursive true
    end

    file "#{Chef::Config[:file_cache_path]}/reprepro-private.key" do
      content new_resource.pgp_private
      owner 'root'
      group 'root'
      mode '0600'
      sensitive true
    end

    execute 'import reprepro packaging key' do
      command "gpg --import #{Chef::Config[:file_cache_path]}/reprepro-private.key"
      user 'root'
      cwd '/root'
      environment 'GNUPGHOME' => new_resource.gnupg_home
      not_if { new_resource.pgp_email && shell_out(key_guard).exitstatus.zero? }
    end
  end

  if new_resource.pgp_public && pgp_key_path
    template pgp_key_path do
      source 'pgp_key.erb'
      cookbook 'reprepro'
      mode '0644'
      owner new_resource.repo_owner
      group new_resource.repo_group
      sensitive true
      variables(pgp_public: new_resource.pgp_public)
    end
  elsif new_resource.pgp_email && pgp_key_path
    execute "export reprepro public key #{new_resource.pgp_email}" do
      command "gpg --armor --export #{new_resource.pgp_email} > #{pgp_key_path}"
      creates pgp_key_path
      environment 'GNUPGHOME' => new_resource.gnupg_home
      only_if "GNUPGHOME=#{new_resource.gnupg_home} gpg --list-keys #{new_resource.pgp_email}"
    end

    file pgp_key_path do
      mode '0644'
      owner new_resource.repo_owner
      group new_resource.repo_group
      only_if { ::File.exist?(pgp_key_path) }
    end
  end

  apt_repository 'reprepro' do
    uri "file://#{new_resource.repo_dir}"
    components new_resource.local_repository_components
    trusted true unless new_resource.pgp_email
    action :add
    only_if { new_resource.enable_repository_on_host }
  end
end

action :delete do
  apt_repository 'reprepro' do
    action :remove
    only_if { new_resource.enable_repository_on_host }
  end

  directory new_resource.incoming do
    recursive true
    action :delete
  end

  directory new_resource.repo_dir do
    recursive true
    action :delete
  end
end
