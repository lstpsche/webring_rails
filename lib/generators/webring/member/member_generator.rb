require 'rails/generators/active_record'
require 'rails/generators/named_base'
require_relative '../shared/route_injector'

module Webring
  module Generators
    # @description The MemberGenerator creates the Member model, which is the core of the webring
    # It creates both the model file and a migration to create the database table
    #
    # @usage Run: rails generate webring:member
    #
    # @example Generated Member model has the following attributes:
    #   # uid  - A unique identifier for the member (automatically generated)
    #   # name - The name of the member site (defaults to URL if not provided)
    #   # url  - The URL of the member site (required)
    #   # description - The description of the member site (required)
    #
    # @note After running this generator, you should run the migration with:
    #       rails db:migrate
    class MemberGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      include Shared::RouteInjector

      source_root File.expand_path('templates', __dir__)

      desc 'Creates a Webring::Member model and necessary migration for storing webring members'

      # Creates a migration file to create the webring_members table
      # @return [void]
      def create_migration_file
        migration_template 'migration.rb', 'db/migrate/create_webring_members.rb'
      end

      # Creates the Member model file based on the template
      # @return [void]
      def create_model_file
        template 'model.rb', 'app/models/webring/member.rb'
      end

      # Generates the next migration number for the migration file
      # This is required by Rails::Generators::Migration
      # @param dirname [String] The directory where migrations are stored
      # @return [Integer] The next migration number
      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      # Displays the README with next steps after installation
      # @return [void]
      def show_readme
        readme 'AFTER_INSTALL' if behavior == :invoke
      end
    end
  end
end
