require 'rails/engine'

module RailsPresence
  class Engine < ::Rails::Engine
    isolate_namespace RailsPresence

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "rails_presence.assets.precompile" do |app|
      app.config.assets.precompile += %w( rails_presence/application.js rails_presence/application.css )
    end
  end
end
