module Webring
  module Generators
    module Shared
      module RouteInjector
        private

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

        def inject_routes_into_main_app(route_content)
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
