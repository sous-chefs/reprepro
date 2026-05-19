# frozen_string_literal: true

require 'spec_helper'

describe 'reprepro_nginx' do
  step_into :reprepro_nginx
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      reprepro_nginx 'apt_repo' do
        fqdn 'apt.example.test'
      end
    end

    it { is_expected.to install_nginx_install('nginx').with(source: 'distro') }
    it { is_expected.to create_nginx_config('nginx').with(default_site_enabled: false) }
    it { is_expected.to create_nginx_site('apt_repo') }
    it { is_expected.to enable_nginx_service('nginx') }
    it { is_expected.to start_nginx_service('nginx') }
  end

  context 'with action delete' do
    recipe do
      reprepro_nginx 'apt_repo' do
        action :delete
      end
    end

    it { is_expected.to delete_nginx_site('apt_repo') }
  end
end
