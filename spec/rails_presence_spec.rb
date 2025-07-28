require 'spec_helper'

RSpec.describe RailsPresence do
  it "has a version number" do
    expect(RailsPresence::VERSION).not_to be nil
  end

  describe "configuration" do
    it "has default timeout" do
      expect(RailsPresence.default_timeout).to eq(5.minutes)
    end

    it "has default cleanup interval" do
      expect(RailsPresence.cleanup_interval).to eq(1.minute)
    end

    it "allows configuration" do
      RailsPresence.configure do |config|
        config.default_timeout = 10.minutes
        config.cleanup_interval = 2.minutes
      end

      expect(RailsPresence.default_timeout).to eq(10.minutes)
      expect(RailsPresence.cleanup_interval).to eq(2.minutes)

      # Reset to defaults
      RailsPresence.default_timeout = 5.minutes
      RailsPresence.cleanup_interval = 1.minute
    end
  end
end
