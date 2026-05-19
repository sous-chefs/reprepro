# frozen_string_literal: true

require 'spec_helper'

describe 'reprepro_apache' do
  step_into :reprepro_apache
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      reprepro_apache 'apt_repo' do
        fqdn 'apt.example.test'
        pgp_email 'packages@example.test'
      end
    end

    it { is_expected.to install_apache2_install('default').with(listen: ['80']) }
    it { is_expected.to enable_apache2_service('default') }
    it { is_expected.to start_apache2_service('default') }
    it { is_expected.to create_template('/etc/apache2/sites-available/apt_repo.conf') }
    it { is_expected.to enable_apache2_site('apt_repo') }
    it { is_expected.to disable_apache2_site('000-default') }
  end

  context 'with action delete' do
    recipe do
      reprepro_apache 'apt_repo' do
        action :delete
      end
    end

    it { is_expected.to disable_apache2_site('apt_repo') }
    it { is_expected.to delete_file('/etc/apache2/sites-available/apt_repo.conf') }
  end
end
