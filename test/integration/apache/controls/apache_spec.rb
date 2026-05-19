# frozen_string_literal: true

control 'reprepro-apache-01' do
  impact 1.0
  title 'apache serves the repository path'

  describe package('apache2') do
    it { should be_installed }
  end

  describe file('/etc/apache2/sites-available/apt_repo.conf') do
    it { should exist }
    its('content') { should match(%r{DocumentRoot /srv/apt}) }
    its('content') { should match(/ServerName apt.example.test/) }
  end
end
