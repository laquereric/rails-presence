require "rails_presence/version"
require "rails_presence/engine"

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
