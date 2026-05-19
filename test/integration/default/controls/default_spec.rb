# frozen_string_literal: true

control 'reprepro-default-01' do
  impact 1.0
  title 'reprepro package is installed'

  describe package('reprepro') do
    it { should be_installed }
  end
end

control 'reprepro-default-02' do
  impact 1.0
  title 'repository directories and configuration files exist'

  %w(/srv/apt /srv/apt/conf /srv/apt/db /srv/apt/dists /srv/apt/pool /srv/apt/tarballs /srv/apt_incoming).each do |repo_path|
    describe directory(repo_path) do
      it { should exist }
    end
  end

  describe file('/srv/apt/conf/distributions') do
    it { should exist }
    its('content') { should match(/Codename: noble/) }
    its('content') { should match(/Architectures: amd64 all source/) }
  end

  describe file('/srv/apt/conf/incoming') do
    it { should exist }
    its('content') { should match(%r{IncomingDir: /srv/apt_incoming}) }
  end

  describe file('/srv/apt/conf/pulls') do
    it { should exist }
    its('content') { should match(/Name: noble/) }
  end
end
