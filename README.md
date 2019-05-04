# reprepro Cookbook

[![CircleCI](https://circleci.com/gh/sous-chefs/reprepro.svg?style=svg)](https://circleci.com/gh/sous-chefs/reprepro) [![Cookbook Version](https://img.shields.io/cookbook/v/reprepro.svg)](https://supermarket.chef.io/cookbooks/reprepro)

Sets up an APT repository suitable for using the reprepro tool to manage distributions and components.

See the reprepro documentation for more information about reprepro itself, including the man(1) page in the package.

- <http://mirrorer.alioth.debian.org/>

## Requirements

### Platforms

- Debian/Ubuntu

### Chef

- Chef 13+

### Cookbooks

- build-essential
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

```
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

This project exists thanks to all the people who contribute.
<img src="https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false" /></a>


### Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/sous-chefs#backer)]
<a href="https://opencollective.com/sous-chefs#backers" target="_blank"><img src="https://opencollective.com/sous-chefs/backers.svg?width=890"></a>

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/sous-chefs#sponsor)]
<a href="https://opencollective.com/sous-chefs/sponsor/0/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/1/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/2/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/3/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/4/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/5/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/6/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/7/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/8/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/9/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/9/avatar.svg"></a>


## License & Authors

- Author: Joshua Timberman ([joshua@chef.io](mailto:joshua@chef.io))
- Author: Chris Roberts ([chrisroberts.code@gmail.com](mailto:chrisroberts.code@gmail.com))

```text
Copyright:: 2013-2015, Chef Software, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
