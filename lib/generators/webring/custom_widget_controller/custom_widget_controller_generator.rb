require_relative '../shared/route_injector'

module Webring
  module Generators
    # @description The CustomWidgetControllerGenerator creates a controller to handle webring custom widgets
    # This generator creates both the controller file and adds the required routes
    #
    # @usage Run: rails generate webring:custom_widget_controller
    #
    # @example The generated controller provides an endpoint for embedding the widget via the <script> tag:
    #   # GET /widget.js - Get the widget's code for a script tag
    #
    # @note This generator should be run after installing the Webring engine
    class CustomWidgetControllerGenerator < Rails::Generators::Base
      include Shared::RouteInjector

      source_root File.expand_path('templates', __dir__)

      desc 'Creates a Webring::CustomWidgetController and necessary routes for custom widget'

      # Creates the CustomWidgetController file based on the template
      def create_controller_file
        template 'custom_widget_controller.rb', 'app/controllers/webring/custom_widget_controller.rb'
      end

      # Adds custom widget routes to the application's routes.rb file
      # These routes are used to create new custom widgets
      def create_custom_widget_routes
        routes_file = 'config/routes.rb'
        widget_route = "get 'widget.js', to: 'widget#show', format: 'js', as: :widget"
        new_widget_route = "get 'widget.js', to: 'custom_widget#show', format: 'js', as: :widget"

        if File.read(routes_file).include?(widget_route)
          gsub_file routes_file, widget_route, new_widget_route
        else
          route_content = <<~ROUTE
            scope module: 'webring' do
              get 'widget.js', to: 'custom_widget#show', format: 'js', as: :widget
            end
          ROUTE

          inject_webring_routes(route_content)
        end
      end
    end
  end
end
