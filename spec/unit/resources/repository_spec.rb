# frozen_string_literal: true

require 'spec_helper'

describe 'reprepro_repository' do
  step_into :reprepro_repository
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      reprepro_repository 'default' do
        fqdn 'apt.example.test'
        codenames %w(noble)
      end
    end

    it { is_expected.to install_build_essential('compilation tools') }
    it { is_expected.to install_package(%w(apt-utils dpkg-dev reprepro debian-keyring devscripts dput)) }
    it { is_expected.to create_directory('/srv/apt').with(owner: 'nobody', group: 'nogroup', mode: '0755') }
    it { is_expected.to create_directory('/srv/apt_incoming').with(owner: 'nobody', group: 'nogroup', mode: '0755') }
    it { is_expected.to create_template('/srv/apt/conf/distributions') }
    it { is_expected.to create_template('/srv/apt/conf/incoming') }
    it { is_expected.to create_template('/srv/apt/conf/pulls') }
  end

  context 'with PGP key material and local repository enabled' do
    before do
      allow_any_instance_of(Chef::Resource).to receive(:shell_out).and_return(double(exitstatus: 1))
    end

    recipe do
      reprepro_repository 'signed' do
        fqdn 'apt.example.test'
        codenames %w(noble)
        pgp_email 'packages@example.test'
        pgp_fingerprint 'ABCD'
        pgp_public 'public-key'
        pgp_private 'private-key'
        enable_repository_on_host true
      end
    end

    it { is_expected.to create_file("#{Chef::Config[:file_cache_path]}/reprepro-private.key").with(sensitive: true) }
    it { is_expected.to run_execute('import reprepro packaging key') }
    it { is_expected.to create_template('/srv/apt/packages@example.test.gpg.key').with(sensitive: true) }
    it { is_expected.to add_apt_repository('reprepro').with(uri: 'file:///srv/apt', components: ['main']) }
  end

  context 'with action delete' do
    recipe do
      reprepro_repository 'default' do
        action :delete
      end
    end

    it { is_expected.to delete_directory('/srv/apt_incoming') }
    it { is_expected.to delete_directory('/srv/apt') }
  end
end
