require 'spec_helper'

RSpec.describe RailsPresense do
  it "has a version number" do
    expect(RailsPresense::VERSION).not_to be nil
  end

  describe "configuration" do
    it "has default timeout" do
      expect(RailsPresense.default_timeout).to eq(5.minutes)
    end

    it "has default cleanup interval" do
      expect(RailsPresense.cleanup_interval).to eq(1.minute)
    end

    it "allows configuration" do
      RailsPresense.configure do |config|
        config.default_timeout = 10.minutes
        config.cleanup_interval = 2.minutes
      end

      expect(RailsPresense.default_timeout).to eq(10.minutes)
      expect(RailsPresense.cleanup_interval).to eq(2.minutes)

      # Reset to defaults
      RailsPresense.default_timeout = 5.minutes
      RailsPresense.cleanup_interval = 1.minute
    end
  end
end
