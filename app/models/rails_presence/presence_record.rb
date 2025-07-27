module RailsPresence
  class PresenceRecord < ActiveRecord::Base
    self.table_name = 'rails_presence_records'

    validates :user_id, presence: true
    validates :identifier, presence: true, uniqueness: { scope: :user_id }

    scope :active, -> { where('last_seen_at > ?', RailsPresence.default_timeout.ago) }
    scope :for_user, ->(user_id) { where(user_id: user_id) }

    def self.touch_presence(user_id, identifier, metadata = {})
      record = find_or_initialize_by(user_id: user_id, identifier: identifier)
      record.last_seen_at = Time.current
      record.metadata = metadata
      record.save!
      record
    end

    def self.cleanup_stale_records
      where('last_seen_at < ?', RailsPresence.default_timeout.ago).delete_all
    end

    def active?
      last_seen_at && last_seen_at > RailsPresence.default_timeout.ago
    end

    def time_since_last_seen
      return 0 if last_seen_at.nil?
      Time.current - last_seen_at
    end
  end
end
