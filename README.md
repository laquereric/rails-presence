# Rails Presence

A Rails engine for managing user presence and online status in real-time. Track when users are active, online, or away in your Rails applications.

## Features

- **Real-time presence tracking** using ActionCable WebSockets
- **Flexible identifier system** - track presence across different contexts (web, mobile, etc.)
- **Automatic cleanup** of stale presence records
- **RESTful API** for presence queries
- **Configurable timeouts** and cleanup intervals
- **Metadata support** for additional presence information

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_presence'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rails_presence

Run the generator to install the required files:

    $ rails generate rails_presence:install
    $ rake db:migrate

## Configuration

Configure Rails Presence in `config/initializers/rails_presence.rb`:

```ruby
RailsPresence.configure do |config|
  # How long to consider a user as "present" after their last activity
  config.default_timeout = 5.minutes
  
  # How often to clean up stale presence records (background job recommended)
  config.cleanup_interval = 1.minute
end
```

## Usage

### Basic Setup

Mount the engine in your `config/routes.rb`:

```ruby
mount RailsPresence::Engine => "/presence"
```

### Tracking Presence

#### In Controllers

Add automatic presence tracking to your controllers:

```ruby
class ApplicationController < ActionController::Base
  before_action :update_user_presence, if: :user_signed_in?

  private

  def update_user_presence
    RailsPresence::PresenceRecord.touch_presence(current_user.id, 'web')
  end
end
```

#### Via API

Update presence manually via POST request:

```javascript
fetch('/presence/update', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
  },
  body: JSON.stringify({
    identifier: 'web',
    metadata: { page: 'dashboard' }
  })
});
```

#### Via ActionCable

Connect to the presence channel:

```javascript
// app/assets/javascripts/channels/presence.js
App.presence = App.cable.subscriptions.create("RailsPresence::PresenceChannel", {
  connected: function() {
    console.log("Connected to presence channel");
    this.perform('ping');
  },

  disconnected: function() {
    console.log("Disconnected from presence channel");
  },

  received: function(data) {
    if (data.type === 'presence_update') {
      console.log('User presence updated:', data);
    }
  },

  updatePresence: function(identifier, metadata) {
    this.perform('update_presence', {
      identifier: identifier,
      metadata: metadata
    });
  }
});

// Update presence every 30 seconds
setInterval(function() {
  App.presence.perform('ping');
}, 30000);
```

### Querying Presence

#### Check if a user is online

```ruby
# Check if user is active
user_active = RailsPresence::PresenceRecord.active.for_user(user_id).any?

# Get all active presence records for a user
records = RailsPresence::PresenceRecord.active.for_user(user_id)
```

#### Via API

```javascript
// Get presence for specific user
fetch('/presence/show?user_id=123')
  .then(response => response.json())
  .then(data => console.log('User presence:', data));

// Get presence for multiple users
fetch('/presence?user_ids[]=123&user_ids[]=456')
  .then(response => response.json())
  .then(data => console.log('Users presence:', data));
```

### Cleanup

Set up a background job to clean up stale records:

```ruby
# In a scheduled job (using whenever, sidekiq-cron, etc.)
RailsPresence::PresenceRecord.cleanup_stale_records
```

## API Reference

### Models

#### `RailsPresence::PresenceRecord`

- `touch_presence(user_id, identifier, metadata = {})` - Update presence for a user
- `cleanup_stale_records` - Remove stale presence records
- `active` - Scope for active presence records
- `for_user(user_id)` - Scope for specific user's records

### Controllers

#### `RailsPresence::PresenceController`

- `POST /presence/update` - Update user presence
- `GET /presence/show` - Get presence for a user
- `GET /presence` - Get presence for multiple users

### Channels

#### `RailsPresence::PresenceChannel`

- `update_presence(data)` - Update presence via WebSocket
- `ping` - Send a ping to maintain connection

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ericlaquer/rails_presence. This project is intended to be a safe, welcoming space for collaboration.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

