name              'reprepro'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs/Configures reprepro for an apt repository'
source_url        'https://github.com/tas50/reprepro'
issues_url        'https://github.com/tas50/reprepro/issues'
chef_version      '>= 14.0'
version           '2.0.1'

# Doesn't make sense to indicate support for non Debian platforms!
supports 'ubuntu'
supports 'debian'

depends 'apache2', '>= 3.0'
depends 'nginx', '>= 7.0'
depends 'gpg'
