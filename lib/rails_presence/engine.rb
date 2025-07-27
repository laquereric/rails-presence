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

    initializer "rails_presence.action_cable" do
      ActiveSupport.on_load(:action_cable) do
        require 'rails_presence/channels/presence_channel'
      end
    end
  end
end
