# frozen_string_literal: true

apt_update

reprepro_repository 'default' do
  fqdn 'apt.example.test'
  description 'APT repository for integration tests'
  codenames ['noble']
  architectures %w(amd64 all source)
  pulls(
    'name' => 'noble',
    'from' => 'noble',
    'component' => 'main'
  )
end
