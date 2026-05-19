# reprepro_apache

Configures Apache to serve a reprepro repository.

## Actions

| Action    | Description                   |
|-----------|-------------------------------|
| `:create` | Creates and enables the site  |
| `:delete` | Disables and removes the site |

## Properties

| Property         | Type        | Default        | Description              |
|------------------|-------------|----------------|--------------------------|
| `site_name`      | String      | name property  | Apache site name         |
| `repo_dir`       | String      | `/srv/apt`     | Repository document root |
| `fqdn`           | String      | `node['fqdn']` | Site FQDN                |
| `server_aliases` | Array       | host and FQDN  | Apache ServerAlias list  |
| `pgp_email`      | String, nil | `nil`          | ServerAdmin value        |
| `listen_port`    | Integer     | `80`           | HTTP listen port         |

## Examples

```ruby
reprepro_apache 'apt_repo' do
  fqdn 'apt.example.com'
  repo_dir '/srv/apt'
  pgp_email 'packages@example.com'
end
```
