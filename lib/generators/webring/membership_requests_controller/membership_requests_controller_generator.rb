require_relative '../shared/route_injector'

module Webring
  module Generators
    # @description The MembershipRequestsControllerGenerator creates a controller to handle webring membership requests
    # This generator creates both the controller file and adds the required routes
    #
    # @usage Run: rails generate webring:controller:membership_requests
    #
    # @example The generated controller provides endpoints for creating membership requests:
    #   # GET /webring/membership_requests/new - Controller for creating a new membership request
    #   # POST /webring/membership_requests    - Create a new membership request
    #
    # @note This generator should be run after installing the Webring engine and
    #       generating the MembershipRequest model with webring:membership_request
    class MembershipRequestsControllerGenerator < Rails::Generators::Base
      include Shared::RouteInjector

      source_root File.expand_path('templates', __dir__)

      desc 'Creates a Webring::MembershipRequestsController and necessary routes for membership requests'

      # Creates the MembershipRequestsController file based on the template
      def create_controller_file
        template 'membership_requests_controller.rb', 'app/controllers/webring/membership_requests_controller.rb'
      end

      # Adds membership request routes to the application's routes.rb file
      # These routes are used to create new membership requests
      def create_membership_request_routes
        route_content = <<~ROUTE
          # Webring membership request routes
          namespace :webring do
            resources :membership_requests, only: [:new, :create]
          end
        ROUTE

        inject_webring_routes(route_content)
      end
    end
  end
end
