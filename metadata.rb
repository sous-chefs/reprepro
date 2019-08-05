name              'reprepro'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs/Configures reprepro for an apt repository'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url        'https://github.com/tas50/reprepro'
issues_url        'https://github.com/tas50/reprepro/issues'
chef_version      '>= 13.0'
version           '1.0.0'

# Doesn't make sense to indicate support for non Debian platforms!
supports 'ubuntu'
supports 'debian'

depends 'build-essential', '>= 5.0'
depends 'apache2', '>= 3.0'
depends 'nginx', '>= 7.0'
depends 'gpg'

recipe 'reprepro', 'Installs and configures reprepro for an apt repository'
