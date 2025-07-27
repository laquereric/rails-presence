require 'rails/generators'
require 'rails/generators/migration'

module RailsPresence
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      
      source_root File.expand_path('../templates', __FILE__)
      
      desc "Install RailsPresence"
      
      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end
      
      def copy_migration
        migration_template "create_rails_presence_records.rb", "db/migrate/create_rails_presence_records.rb"
      end
      
      def copy_initializer
        template "rails_presence.rb", "config/initializers/rails_presence.rb"
      end
      
      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
