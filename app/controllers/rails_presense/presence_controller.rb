module RailsPresense
  class PresenceController < ApplicationController
    before_action :authenticate_user!

    def update
      identifier = params[:identifier] || 'default'
      metadata = params[:metadata] || {}
      
      record = PresenceRecord.touch_presence(current_user.id, identifier, metadata)
      
      # Broadcast presence update
      ActionCable.server.broadcast("presence_#{current_user.id}", {
        type: 'presence_update',
        user_id: current_user.id,
        identifier: identifier,
        last_seen_at: record.last_seen_at,
        metadata: metadata
      })

      render json: { status: 'ok', last_seen_at: record.last_seen_at }
    end

    def show
      user_id = params[:user_id] || current_user.id
      records = PresenceRecord.active.for_user(user_id)
      
      render json: {
        user_id: user_id,
        active: records.any?,
        records: records.map do |record|
          {
            identifier: record.identifier,
            last_seen_at: record.last_seen_at,
            metadata: record.metadata
          }
        end
      }
    end

    def index
      user_ids = params[:user_ids] || []
      presence_data = {}

      user_ids.each do |user_id|
        records = PresenceRecord.active.for_user(user_id)
        presence_data[user_id] = {
          active: records.any?,
          records: records.map do |record|
            {
              identifier: record.identifier,
              last_seen_at: record.last_seen_at,
              metadata: record.metadata
            }
          end
        }
      end

      render json: presence_data
    end

    private

    def authenticate_user!
      # This should be implemented by the host application
      # or you can define your own authentication logic here
      head :unauthorized unless respond_to?(:current_user) && current_user
    end
  end
end
