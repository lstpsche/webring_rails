require 'webring/version'
require 'webring/engine'

module Webring
  mattr_accessor :default_status
  @@default_status = :pending

  # Setup method for configuration
  def self.setup
    yield self
  end
end
