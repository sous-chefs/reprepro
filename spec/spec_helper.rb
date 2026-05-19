# frozen_string_literal: true

require 'chefspec'
require 'chefspec/berkshelf'

module ChefSpec
  class ZeroServer
    def self.setup!; end
    def self.reset!; end
    def self.teardown!; end
  end
end

RSpec.configure do |config|
  config.color = true               # Use color in STDOUT
  config.formatter = :documentation # Use the specified formatter
  config.log_level = :error         # Avoid deprecation notice SPAM
end
