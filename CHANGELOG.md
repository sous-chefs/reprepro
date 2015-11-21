# reprepro Cookbook CHANGELOG
This file is used to list changes made in each version of the reprepro cookbook.

## v0.4.2 (2015-11-20)
- Remove Opscode/Chef as the maintainer.
- Updated Travis to run full integration tests with kitchen-docker
- Added Chef default .rubocop.yml file and resolved all warnings
- Reformatted readme and set the minimum required Chef release to 11.0
- Added basic Chefspec to test the converge
- Add chefignore to limit files uploaded to the Chef server
- Updated Berksfile format and removed yum, which wasn't actually required
- Removed the Chef contributing doc that isn't valid anymore
- Updated development deps in the Gemfile
- Update .gitignore to the chef default

## v0.4.1
- Allow option to use nginx (thanks [gilles](https://github.com/gilles))

## v0.4.0
- **[COOK-3545](https://tickets.opscode.com/browse/COOK-3545)** - Support multiple distribution releases

## v0.3.0
- [COOK-2111] - Add LWRP for reprepro interactions. Allow attribute driven configuration

## v0.2.4
- [COOK-922] - add `allow` to data bag
- Update the readme with data bag info
