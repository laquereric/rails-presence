RailsPresence.configure do |config|
  # How long to consider a user as "present" after their last activity
  # config.default_timeout = 5.minutes
  
  # How often to clean up stale presence records (background job recommended)
  # config.cleanup_interval = 1.minute
end
