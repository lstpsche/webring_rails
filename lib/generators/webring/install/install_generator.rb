module Webring
  module Generators
    # @description The InstallGenerator is the first step to set up the Webring engine
    # It mounts the Webring engine to your Rails application's routes
    #
    # @usage Run: rails generate webring:install
    #
    # @example After installation, the engine will be mounted at /webring
    #   # In your routes.rb
    #   mount Webring::Engine => '/webring', as: 'webring'
    #
    # @note You can change the mount path in your routes.rb file after installation
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Creates Webring routes and mounts the engine in your application.'

      # Adds the engine mount point and widget route to the application's routes.rb file
      def add_webring_routes
        route "scope module: 'webring' do\n  get 'widget.js', to: 'widget#show', format: 'js', as: :widget\nend\n\n"
        route "mount Webring::Engine => '/webring', as: 'webring'\n\n"
      end

      # Displays the README with next steps after installation
      def show_readme
        readme 'AFTER_INSTALL' if behavior == :invoke
      end
    end
  end
end
