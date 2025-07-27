require "rails_presense/version"
require "rails_presense/engine"

module RailsPresense
  # Configuration
  mattr_accessor :default_timeout
  @@default_timeout = 5.minutes

  mattr_accessor :cleanup_interval
  @@cleanup_interval = 1.minute

  def self.configure
    yield self
  end
end
