# frozen_string_literal: true

require 'chefspec'
require 'fileutils'
require 'tmpdir'

module ChefSpec
  class ZeroServer
    def self.setup!; end
    def self.reset!; end
    def self.teardown!; end
  end
end

RSpec.configure do |config|
  cookbook_path = File.join(Dir.tmpdir, 'reprepro-chefspec-cookbooks')
  sous_chefs_root = File.expand_path('../..', __dir__)
  FileUtils.rm_rf(cookbook_path) if File.exist?(cookbook_path) || File.symlink?(cookbook_path)
  FileUtils.mkdir_p(cookbook_path)
  %w(reprepro apache2 nginx yum-epel).each do |cookbook|
    FileUtils.ln_sf(File.join(sous_chefs_root, cookbook), File.join(cookbook_path, cookbook))
  end

  config.color = true               # Use color in STDOUT
  config.formatter = :documentation # Use the specified formatter
  config.log_level = :error         # Avoid deprecation notice SPAM
  config.cookbook_path = [cookbook_path]
end
