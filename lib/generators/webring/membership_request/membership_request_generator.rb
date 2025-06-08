require 'rails/generators/active_record'
require 'rails/generators/named_base'
require_relative '../shared/route_injector'

module Webring
  module Generators
    # @description The MembershipRequestGenerator creates the MembershipRequest model for handling webring membership requests
    # It creates both the model file and a migration to create the database table
    #
    # @usage Run: rails generate webring:membership_request
    #
    # @example Generated MembershipRequest model has the following attributes:
    #   # name - The name of the member site
    #   # url - The URL of the member site (required)
    #   # callback_email - Email for notifications
    #   # description - Description of the site
    #
    # @note After running this generator, you should run the migration with:
    #       rails db:migrate
    class MembershipRequestGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      include Shared::RouteInjector

      source_root File.expand_path('templates', __dir__)

      desc 'Creates a Webring::MembershipRequest model and necessary migration for storing webring membership requests'

      # Creates a migration file to create the webring_membership_requests table
      def create_migration_file
        migration_template 'migration.rb', 'db/migrate/create_webring_membership_requests.rb'
        migration_template 'relations_migration.rb', 'db/migrate/add_membership_request_to_webring_members.rb'
      end

      # Creates the MembershipRequest model file based on the template
      def create_model_file
        template 'model.rb', 'app/models/webring/membership_request.rb'
      end

      # Injects the belongs_to relationship into the Member model
      def inject_into_member_model
        member_model_path = 'app/models/webring/member.rb'

        inject_conditions = [
          { line: 'UID_LENGTH =', inject_options: { after: /UID_LENGTH =.*\n\n/ } },
          { line: 'extend Webring::Navigation', inject_options: { after: "extend Webring::Navigation\n\n" } },
          { line: 'class Member < ApplicationRecord', inject_options: { after: "class Member < ApplicationRecord\n" } }
        ]

        if File.exist?(member_model_path)
          content = File.read(member_model_path)
          options = inject_conditions.find { |condition| content.include?(condition[:line]) }&.fetch(:inject_options)
          return if options.nil? || options.empty?

          inject_into_file member_model_path, **options do
            "    belongs_to :membership_request,\n" \
            "               class_name: 'Webring::MembershipRequest',\n" \
            "               foreign_key: :webring_membership_request_id,\n" \
            "               optional: true,\n" \
            "               inverse_of: :member\n" \
            "\n"
          end
        end
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
      def show_readme
        readme 'AFTER_INSTALL' if behavior == :invoke
      end
    end
  end
end
