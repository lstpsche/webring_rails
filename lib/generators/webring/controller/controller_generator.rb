module Webring
  module Generators
    class ControllerGenerator < Rails::Generators::Base
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

        cleared_route_content = route_content.gsub(/^/, '  ')
        routes_file = 'config/routes.rb'
        mount_point = "mount Webring::Engine => '/webring', as: 'webring'\n"

        if File.read(routes_file).include?(mount_point)
          inject_into_file routes_file, after: mount_point do
            "\n#{cleared_route_content}\n"
          end
        else
          route "#{cleared_route_content}\n"
        end
      end
    end
  end
end
