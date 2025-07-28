# Create presence concern
module RailsPresence
module PresenceTrackable
    extend ActiveSupport::Concern

    included do
        has_many :user_presences, dependent: :destroy
    end

    def update_presence(status, room_id = nil)
        presence = user_presences.find_or_initialize_by(room_id: room_id)
        presence.update(last_seen: Time.current)
        update(status: status)
    end

    def touch_presence
        update(status: 'online') if status == 'offline'
        user_presences.update_all(last_seen: Time.current)
    end

    def online?
        status == 'online' && user_presences.where('last_seen > ?', 5.minutes.ago).exists?
    end
end
end

