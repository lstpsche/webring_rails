require_relative '../shared/route_injector'

module Webring
  module Generators
    # @description The ControllerGenerator creates a NavigationController to handle webring navigation
    # This generator creates both the controller file and adds the required routes
    #
    # @usage Run: rails generate webring:controller
    #
    # @example The generated controller provides three main navigation endpoints:
    #   # GET /webring/next     - Navigate to the next site in the webring
    #   # GET /webring/previous - Navigate to the previous site in the webring
    #   # GET /webring/random   - Navigate to a random site in the webring
    #
    # @note This generator should be run after installing the Webring engine and
    #       generating the Member model with webring:member
    class NavigationControllerGenerator < Rails::Generators::Base
      include Shared::RouteInjector

      source_root File.expand_path('templates', __dir__)

      desc 'Creates a Webring::NavigationController and necessary routes for webring navigation'

      # Creates the NavigationController file based on the template
      def create_controller_file
        template 'navigation_controller.rb', 'app/controllers/webring/navigation_controller.rb'
      end

      # Adds navigation routes to the application's routes.rb file
      # These routes are used to navigate between webring members
      def create_navigation_routes
        route_content = <<~ROUTE
          # Webring navigation routes
          namespace :webring do
            root to: 'navigation#random'

            get 'next', to: 'navigation#next'
            get 'previous', to: 'navigation#previous'
            get 'random', to: 'navigation#random'
          end
        ROUTE

        inject_webring_routes(route_content)
      end
    end
  end
end
