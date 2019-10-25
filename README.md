# reprepro Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/reprepro.svg)](https://supermarket.chef.io/cookbooks/reprepro)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/reprepro/master.svg)](https://circleci.com/gh/sous-chefs/reprepro)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Sets up an APT repository suitable for using the reprepro tool to manage distributions and components.

See the reprepro documentation for more information about reprepro itself, including the man(1) page in the package [http://mirrorer.alioth.debian.org/](http://mirrorer.alioth.debian.org/)

## Help Wanted

This repository has been archived for now, but if you want to help us with this cookbook drop by our slack channel #sous-chef on the chef community slack and let us know!

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Debian/Ubuntu

### Chef

- Chef 14+

### Cookbooks

- nginx
- apache2
- gpg

You'll need to generate the PGP key separately and provide the data in the databag.

## Attributes

Attributes in this cookbook are set via the default recipe with data from the data bag. The following attributes are used, in the `reprepro` namespace.

- `fqdn` - the fqdn that would go in sources.list
- `description` - a description of the repository
- `pgp_email` - the email address of the pgp key
- `pgp_fingerprint` - the finger print of the pgp key

## Data Bag based repository

Create a data bag to store the repository information. It should be named `reprepro`. The recipe uses the `main` data bag item.

```ruby
{
  "id": "main",
  "fqdn": "apt.example.com",
  "repo_dir": "/srv/apt",
  "incoming": "/srv/apt_incoming",
  "description": "APT Repository for our packages.",
  "codenames": [
    "lucid", "hardy", "sid", "squeeze", "lenny"
  ],
  "allow": [
    "unstable>sid", "stable>squeeze"
  ],
  "pgp": {
    "email": "packages@example.com",
    "fingerprint": "PGP Fingerprint for the key",
    "public": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n-----END PGP PUBLIC KEY BLOCK-----\n",
    "private": "-----BEGIN PGP PRIVATE KEY BLOCK-----\n-----END PGP PRIVATE KEY BLOCK-----\n"
  },
  "pulls": {
    "name": "sid",
    "from": "sid",
    "component": "main"
  },
  "architectures": [
    "amd64","i386","all","source"
  ]
}
```

- `fqdn`: the fully qualified domain name of the apt server, used in
- in the Apache vhost template and as the Origin in the distributions
- configuration. Also saved to the node as
- `node['reprepro']['fqdn]`.
- `repo_dir`: directory on disk where reprepro will serve the packages
- `incoming`: the incoming directory, used in the incoming
- configuration.
- `description`: description about the repository, also saved to the
- node as `node['reprepro']['description']`.
- `codenames`: array of codenames to set up for the repository, used
- with allow for the Allow directive in the incoming configuration
- `allow`: [optional] array of additional codenames to use in the incoming
- configuration
- `pgp`: hash of options for the pgp setup. the
- `pgp['email']`: email address of the signing key
- `pgp['fingerprint]`: fingerprint of the PGP key
- `pgp['public]`: the public PGP key, should be a single line
- (replace line endings with \n)
- `pgp['private]`: the private PGP key, should be a single line
- (replace line endings with \n)
- `pulls`: hash used in the pulls configuration.
- `architectures`: array of architectures to create in distributions configuration

## Attribute based configuration

Configuration of the repository can also be driven via attributes. The same keys available for the data bag are available via node attributes with the exception of the `pgp` hash. Using attribute based configuration will have a PGP key pair auto generated on the node when it is built.

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
