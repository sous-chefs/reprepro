# frozen_string_literal: true

if ENV['SOUS_CHEFS_BERKS_SOURCE']
  source({ chef_repo: ENV['SOUS_CHEFS_BERKS_SOURCE'] })
else
  source 'https://supermarket.chef.io'
end

metadata

cookbook 'apache2', path: '../apache2'
cookbook 'nginx', path: '../nginx'
cookbook 'yum-epel', path: '../yum-epel'

group :integration do
  cookbook 'test', path: 'test/cookbooks/test'
end
