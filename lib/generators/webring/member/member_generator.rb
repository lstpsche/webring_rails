require 'rails/generators/active_record'
require 'rails/generators/named_base'
require_relative '../shared/route_injector'

module Webring
  module Generators
    class MemberGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      include Shared::RouteInjector

      source_root File.expand_path('templates', __dir__)

      desc 'Creates a Webring::Member model and necessary migration'

      def create_migration_file
        migration_template 'migration.rb', 'db/migrate/create_webring_members.rb'
      end

      def create_model_file
        template 'model.rb', 'app/models/webring/member.rb'
      end

      def create_routes
        route_content = <<~ROUTE
          # Webring member routes
          namespace :webring do
            resources :members
          end
        ROUTE

        inject_webring_routes(route_content)
      end

      # required by Rails::Generators::Migration
      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def show_readme
        readme 'AFTER_INSTALL' if behavior == :invoke
      end
    end
  end
end
