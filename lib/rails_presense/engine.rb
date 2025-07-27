require 'rails/engine'

module RailsPresense
  class Engine < ::Rails::Engine
    isolate_namespace RailsPresense

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "rails_presense.assets.precompile" do |app|
      app.config.assets.precompile += %w( rails_presense/application.js rails_presense/application.css )
    end

    initializer "rails_presense.action_cable" do
      ActiveSupport.on_load(:action_cable) do
        require 'rails_presense/channels/presence_channel'
      end
    end
  end
end
