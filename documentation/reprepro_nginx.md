# reprepro_nginx

Configures Nginx to serve a reprepro repository.

## Actions

| Action    | Description                  |
|-----------|------------------------------|
| `:create` | Creates and enables the site |
| `:delete` | Removes the site             |

## Properties

| Property              | Type        | Default        | Description                  |
|-----------------------|-------------|----------------|------------------------------|
| `site_name`           | String      | name property  | Nginx site name              |
| `repo_dir`            | String      | `/srv/apt`     | Repository document root     |
| `fqdn`                | String      | `node['fqdn']` | Site FQDN                    |
| `listen_port`         | Integer     | `80`           | HTTP listen port             |
| `ssl`                 | true, false | `false`        | Enable HTTPS listener        |
| `ssl_certificate`     | String, nil | `nil`          | SSL certificate path         |
| `ssl_certificate_key` | String, nil | `nil`          | SSL certificate key path     |

## Examples

```ruby
reprepro_nginx 'apt_repo' do
  fqdn 'apt.example.com'
  repo_dir '/srv/apt'
end
```
