<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Rails Presence Engine Development Guidelines

This is a Rails engine gem that provides real-time user presence tracking functionality. When working on this project, please follow these guidelines:

## Code Style & Conventions
- Follow Rails conventions and Ruby style guide
- Use proper namespacing under `RailsPresence` module
- Maintain backwards compatibility when making changes
- Write comprehensive tests using RSpec

## Engine Structure
- All models, controllers, and channels should be namespaced under `RailsPresence`
- Use `isolate_namespace RailsPresence` in the engine configuration
- Place engine-specific code in the `app/` directory
- Keep the main entry point in `lib/rails_presence.rb`

## Features Focus
- Real-time presence tracking using ActionCable
- RESTful API for presence queries
- Configurable timeouts and cleanup intervals
- Support for multiple presence identifiers per user
- Metadata support for additional context

## Testing
- Test all public APIs and core functionality
- Mock external dependencies appropriately
- Test both successful and error scenarios
- Ensure thread safety for concurrent access

## Documentation
- Update README.md with any new features or API changes
- Include code examples for common use cases
- Document configuration options clearly
- Maintain API reference documentation
