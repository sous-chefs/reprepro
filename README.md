# reprepro Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/reprepro.svg)](https://supermarket.chef.io/cookbooks/reprepro)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/reprepro/master.svg)](https://circleci.com/gh/sous-chefs/reprepro)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Provides custom resources that set up an APT repository suitable for using the reprepro tool to manage distributions and components.

See the reprepro documentation for more information about reprepro itself, including the man(1) page in the package [http://mirrorer.alioth.debian.org/](http://mirrorer.alioth.debian.org/)

## Help Wanted

This repository has been archived for now, but if you want to help us with this cookbook drop by our slack channel #sous-chef on the chef community slack and let us know!

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Debian/Ubuntu

### Chef

- Chef 15.3+

### Cookbooks

- nginx
- apache2
You'll need to generate the PGP key separately and provide it as resource properties or manage it before converging the repository resource.

## Resources

- [reprepro_repository](documentation/reprepro_repository.md)
- [reprepro_apache](documentation/reprepro_apache.md)
- [reprepro_nginx](documentation/reprepro_nginx.md)
- [reprepro_deb](documentation/reprepro_deb.md)

## Migration

This cookbook no longer ships recipes or attributes. See [migration.md](migration.md) for the breaking change from `node['reprepro']` attributes and `reprepro::default` recipes to resource properties.

## Repository

Create a repository by declaring `reprepro_repository` directly.

```ruby
reprepro_repository 'default' do
  fqdn 'apt.example.com'
  repo_dir '/srv/apt'
  incoming '/srv/apt_incoming'
  description 'APT Repository for our packages'
  codenames %w(noble jammy)
  allow ['unstable>sid', 'stable>squeeze']
  pgp_email 'packages@example.com'
  pgp_fingerprint 'PGP Fingerprint for the key'
  pgp_public "-----BEGIN PGP PUBLIC KEY BLOCK-----\n-----END PGP PUBLIC KEY BLOCK-----\n"
  pgp_private "-----BEGIN PGP PRIVATE KEY BLOCK-----\n-----END PGP PRIVATE KEY BLOCK-----\n"
  pulls(
    'name' => 'noble',
    'from' => 'noble',
    'component' => 'main'
  )
  architectures %w(amd64 i386 all source)
end
```

## Web Servers

Serve the repository with Apache or Nginx.

```ruby
reprepro_apache 'apt_repo' do
  fqdn 'apt.example.com'
  repo_dir '/srv/apt'
  pgp_email 'packages@example.com'
end
```

```ruby
reprepro_nginx 'apt_repo' do
  fqdn 'apt.example.com'
  repo_dir '/srv/apt'
end
```

## Package Management

Add or remove `.deb` files.

```ruby
reprepro_deb '/tmp/example_1.0.0_amd64.deb' do
  distribution 'noble'
  action :add
end
```

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
