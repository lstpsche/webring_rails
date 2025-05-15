module Webring
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Creates Webring initializer and route files to your application.'

      def copy_initializer
        template 'webring.rb', 'config/initializers/webring.rb'
      end

      def add_webring_routes
        route "mount Webring::Engine => '/webring', as: 'webring'\n\n"
      end

      def show_readme
        readme 'AFTER_INSTALL' if behavior == :invoke
      end
    end
  end
end
