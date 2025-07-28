module RailsPresence
  class HealthController < ApplicationController
    # Skip authentication for health checks
    skip_before_action :verify_authenticity_token, only: [:show]
    
    def show
      health_status = {
        status: 'ok',
        timestamp: Time.current.iso8601,
        version: RailsPresence::VERSION,
        services: check_services
      }
      
      # Determine HTTP status based on service health
      http_status = health_status[:services].values.all? { |status| status[:status] == 'ok' } ? 200 : 503
      
      render json: health_status, status: http_status
    end
    
    private
    
    def check_services
      {
        database: check_database,
        action_cable: check_action_cable,
        presence_records: check_presence_records
      }
    end
    
    def check_database
      begin
        # Simple database connectivity check
        ActiveRecord::Base.connection.execute('SELECT 1')
        { status: 'ok', message: 'Database connection successful' }
      rescue => e
        { status: 'error', message: "Database connection failed: #{e.message}" }
      end
    end
    
    def check_action_cable
      begin
        # Check if ActionCable server is available
        if defined?(ActionCable) && ActionCable.server
          { status: 'ok', message: 'ActionCable server available' }
        else
          { status: 'error', message: 'ActionCable server not available' }
        end
      rescue => e
        { status: 'error', message: "ActionCable check failed: #{e.message}" }
      end
    end
    
    def check_presence_records
      begin
        # Check if we can query presence records
        count = PresenceRecord.count
        active_count = PresenceRecord.active.count
        
        {
          status: 'ok',
          message: 'Presence records accessible',
          total_records: count,
          active_records: active_count
        }
      rescue => e
        { status: 'error', message: "Presence records check failed: #{e.message}" }
      end
    end
  end
end