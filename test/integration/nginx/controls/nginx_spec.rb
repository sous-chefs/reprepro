# frozen_string_literal: true

control 'reprepro-nginx-01' do
  impact 1.0
  title 'nginx serves the repository path'

  describe package('nginx') do
    it { should be_installed }
  end

  describe file('/etc/nginx/sites-available/apt_repo.conf') do
    it { should exist }
    its('content') { should match(%r{root /srv/apt;}) }
    its('content') { should match(/server_name apt.example.test;/) }
  end
end
