require_relative '../shared/route_injector'

module Webring
  module Generators
    class ControllerGenerator < Rails::Generators::Base
      include Shared::RouteInjector

      source_root File.expand_path('templates', __dir__)

      desc 'Creates a Webring::NavigationController and necessary routes'

      def create_controller_file
        template 'navigation_controller.rb', 'app/controllers/webring/navigation_controller.rb'
      end

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
