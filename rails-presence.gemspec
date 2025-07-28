# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_presence/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-presence"
  spec.version       = RailsPresence::VERSION
  spec.authors       = ["Eric Laquer"]
  spec.email         = ["laquereric@gmail.com"]

  spec.summary       = %q{A Rails engine for managing user presence and online status.}
  spec.description   = %q{Rails Presence provides real-time user presence tracking, online status management, and activity monitoring for Rails applications.}
  spec.homepage      = "https://github.com/ericlaquer/rails_presence"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Rails engine dependencies
  spec.add_dependency "rails", ">= 4.2.0"
  spec.add_dependency "actioncable", ">= 5.0.0"
  
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "sqlite3"
end
