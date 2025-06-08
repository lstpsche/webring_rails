module Webring
  module Generators
    module Shared
      # @description The RouteInjector module provides utility methods for injecting routes
      # into the application's routes.rb file. It's used by various Webring generators
      # to add their respective routes.
      #
      # @usage Include this module in a generator class:
      #   include Webring::Generators::Shared::RouteInjector
      #
      # @example
      #   # Then you can use the inject_webring_routes method:
      #   inject_webring_routes("namespace :webring do\n  resources :members\nend")
      module RouteInjector
        private

        # Injects routes into the application's routes.rb file
        # If the Webring engine is already mounted, this will add the routes
        # right after the engine's mount point. Otherwise, it will add them
        # to the end of the routes file.
        #
        # @param route_content [String] The routes to be added
        def inject_webring_routes(route_content)
          cleared_route_content = route_content.gsub(/^/, '  ')
          routes_file = 'config/routes.rb'
          mount_point = "mount Webring::Engine => '/webring', as: 'webring'\n"

          if File.read(routes_file).include?(mount_point)
            inject_into_file routes_file, after: mount_point do
              "\n#{cleared_route_content}"
            end
          else
            route "#{cleared_route_content}\n"
          end
        end
      end
    end
  end
end
