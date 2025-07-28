require "rails-presence/version"

module RailsPresence
  # Configuration
  mattr_accessor :default_timeout
  @@default_timeout = 5.minutes

  mattr_accessor :cleanup_interval
  @@cleanup_interval = 1.minute

  def self.configure
    yield self
  end
end

# Load the engine after the module is defined
require "rails-presence/engine"
