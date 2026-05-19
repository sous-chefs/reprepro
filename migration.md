# Migration

This release removes the legacy `reprepro::default`, `reprepro::apache`, and `reprepro::nginx` recipes and the `node['reprepro']` attribute API.

Use custom resources directly from your own wrapper cookbook or Policyfile run list.

## Repository

```ruby
reprepro_repository 'default' do
  fqdn 'apt.example.com'
  description 'APT Repository for our packages'
  codenames %w(noble jammy)
  architectures %w(amd64 i386 all source)
  pulls(
    'name' => 'noble',
    'from' => 'noble',
    'component' => 'main'
  )
  pgp_email 'packages@example.com'
  pgp_public "-----BEGIN PGP PUBLIC KEY BLOCK-----\n-----END PGP PUBLIC KEY BLOCK-----\n"
  pgp_private "-----BEGIN PGP PRIVATE KEY BLOCK-----\n-----END PGP PRIVATE KEY BLOCK-----\n"
end
```

The old data bag lookup from `reprepro::default` is intentionally not preserved. Read the data bag in your wrapper cookbook if you still store repository settings there, then pass the values as resource properties.

## Apache

```ruby
reprepro_apache 'apt_repo' do
  fqdn 'apt.example.com'
  repo_dir '/srv/apt'
  pgp_email 'packages@example.com'
end
```

## Nginx

```ruby
reprepro_nginx 'apt_repo' do
  fqdn 'apt.example.com'
  repo_dir '/srv/apt'
end
```

## Debian Packages

```ruby
reprepro_deb '/tmp/example_1.0.0_amd64.deb' do
  distribution 'noble'
  repo_dir '/srv/apt'
  action :add
end
```
