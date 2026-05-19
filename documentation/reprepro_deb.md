# reprepro_deb

Adds or removes Debian packages from a reprepro repository.

## Actions

| Action    | Description                           |
|-----------|---------------------------------------|
| `:add`    | Adds a `.deb` package                 |
| `:remove` | Removes a package from the repository |

## Properties

| Property       | Type          | Default              | Description                         |
|----------------|---------------|----------------------|-------------------------------------|
| `package`      | String        | name property        | Path to the `.deb` package          |
| `package_name` | String, nil   | `.deb` basename      | Package name for removal            |
| `distribution` | String, Array | current LSB codename | Distribution codenames              |
| `repo_dir`     | String        | `/srv/apt`           | Repository root directory           |
| `gnupg_home`   | String        | `/root/.gnupg`       | GNUPG home used by reprepro         |

## Examples

```ruby
reprepro_deb '/tmp/example_1.0.0_amd64.deb' do
  distribution 'noble'
  action :add
end
```

```ruby
reprepro_deb '/tmp/example_1.0.0_amd64.deb' do
  package_name 'example'
  distribution %w(noble jammy)
  action :remove
end
```
