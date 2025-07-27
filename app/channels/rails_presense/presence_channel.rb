module RailsPresense
  class PresenceChannel < ActionCable::Channel::Base
    def subscribed
      stream_from "presence_#{current_user.id}" if current_user
    end

    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end

    def update_presence(data)
      return unless current_user

      identifier = data['identifier'] || 'default'
      metadata = data['metadata'] || {}
      
      record = PresenceRecord.touch_presence(current_user.id, identifier, metadata)
      
      # Broadcast to all subscribers of this user's presence
      ActionCable.server.broadcast("presence_#{current_user.id}", {
        type: 'presence_update',
        user_id: current_user.id,
        identifier: identifier,
        last_seen_at: record.last_seen_at,
        metadata: metadata
      })
    end

    def ping
      return unless current_user

      identifier = 'websocket'
      record = PresenceRecord.touch_presence(current_user.id, identifier, { source: 'ping' })
      
      transmit({
        type: 'pong',
        last_seen_at: record.last_seen_at
      })
    end

    private

    def current_user
      # This should be implemented by the host application
      # You might want to use connection identifiers or custom logic
      connection.current_user if connection.respond_to?(:current_user)
    end
  end
end
