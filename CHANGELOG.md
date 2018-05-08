# reprepro Cookbook CHANGELOG

This file is used to list changes made in each version of the reprepro cookbook.

## v1.0.0 (2018-05-08)

- Remove compat_resource usage and require Chef 13+ instead
- Use build_essential resource not the recipe to allow this to run without the cookbook on chef 14+
- Convert the resource from a LWRP to a custom new_resource
- Switch from chef_nginx to nginx cookbook and update the nginx_site usage for the new nginx_site custom resource
- Use the correct action for ruby_block to resolve foodcritic warnings
- Don't manually update the convert status on the resource. Let Chef do this the right way
- Properly set the name_property on the resource
- Property set the distribution default value in the resource
- Switch from symbols to strings in the templates to resolve warnings

## v0.5.0 (2017-05-31)

- Turned on use_inline_resource in the provider
- Switched from nginx to chef_nginx
- Set reasonable minimum versions of the required cookbooks
- Increased the required chef release to 12.1+
- Added source_url, issues_url, and chef_version to the metadata
- Removed "suggests" metadata as this doesn't actually do anything
- Updated notification to the Chef 10+ syntax
- Added a test cookbook that includes both apache and nginx testing
- Swapped apt cookbook for compat_resource on older chef releases
- Stopped including the default apt cookbook within the recipe. Getting apt-update run is outside the scope of this cookbook. It should be done in a base recipe with the apt_update resource
- Fixed the apache listen attribute to use the current attribute name
- Stopped using node.set, which is deprecated
- Removed test gems from the Gemfile
- Added a Delivery local mode config for simple testing
- Setup Travis CI to use ChefDK and kitchen-dokken for integration testing
- Switched from rubocop to cookstyle
- Switched from kitchen-docker to kitchen-dokken

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
