require 'rails/generators'
require 'rails/generators/migration'

module RailsPresense
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      
      source_root File.expand_path('../templates', __FILE__)
      
      desc "Install RailsPresense"
      
      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end
      
      def copy_migration
        migration_template "create_rails_presense_records.rb", "db/migrate/create_rails_presense_records.rb"
      end
      
      def copy_initializer
        template "rails_presense.rb", "config/initializers/rails_presense.rb"
      end
      
      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
