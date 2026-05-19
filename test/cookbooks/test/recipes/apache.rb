# frozen_string_literal: true

include_recipe 'test::default'

reprepro_apache 'apt_repo' do
  fqdn 'apt.example.test'
end
