# frozen_string_literal: true

name 'reprepro'

default_source :supermarket

run_list 'recipe[test::default]'

cookbook 'reprepro', path: '.'
cookbook 'test', path: './test/cookbooks/test'

named_run_list :default, 'recipe[test::default]'
named_run_list :nginx, 'recipe[test::nginx]'
named_run_list :apache, 'recipe[test::apache]'
