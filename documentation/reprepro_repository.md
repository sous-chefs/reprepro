# reprepro_repository

Creates and removes a reprepro APT repository layout and configuration.

## Actions

| Action    | Description                    |
|-----------|--------------------------------|
| `:create` | Creates the repository         |
| `:delete` | Removes the repository layout  |

## Properties

| Property                      | Type        | Default                    | Description                                   |
|-------------------------------|-------------|----------------------------|-----------------------------------------------|
| `repo_name`                   | String      | name property              | Repository instance name                      |
| `fqdn`                        | String      | `node['fqdn']`             | Repository FQDN                               |
| `description`                 | String      | `APT repository at <fqdn>` | Repository description                        |
| `repo_dir`                    | String      | `/srv/apt`                 | Repository root directory                     |
| `incoming`                    | String      | `/srv/apt_incoming`        | Incoming package directory                    |
| `codenames`                   | Array       | current LSB codename       | Distribution codenames                        |
| `allow`                       | Array       | `[]`                       | Extra incoming Allow entries                  |
| `pulls`                       | Hash        | current codename/main      | Pull configuration                            |
| `architectures`               | Array       | `i386`, `amd64`            | Repository architectures                      |
| `gnupg_home`                  | String      | `/root/.gnupg`             | GNUPG home for signing keys                   |
| `pgp_email`                   | String, nil | `nil`                      | Signing key email                             |
| `pgp_fingerprint`             | String, nil | `nil`                      | Expected signing key fingerprint              |
| `pgp_public`                  | String, nil | `nil`                      | Public PGP key content                        |
| `pgp_private`                 | String, nil | `nil`                      | Private PGP key content                       |
| `repo_owner`                  | String      | `nobody`                   | Repository file owner                         |
| `repo_group`                  | String      | `nogroup`                  | Repository file group                         |
| `packages`                    | Array       | distro package list        | Packages to install                           |
| `install_build_tools`         | true, false | `true`                     | Install build tools                           |
| `enable_repository_on_host`   | true, false | `false`                    | Add the repository to local APT               |
| `local_repository_components` | Array       | `main`                     | Components for local APT repository entry     |

## Examples

```ruby
reprepro_repository 'default' do
  fqdn 'apt.example.com'
  codenames %w(noble jammy)
  architectures %w(amd64 i386 all source)
  pgp_email 'packages@example.com'
  pgp_public "-----BEGIN PGP PUBLIC KEY BLOCK-----\n-----END PGP PUBLIC KEY BLOCK-----\n"
end
```
