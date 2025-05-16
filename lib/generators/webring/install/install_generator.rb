module Webring
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Creates Webring routes to your application.'

      def add_webring_routes
        route "mount Webring::Engine => '/webring', as: 'webring'\n\n"
      end

      def show_readme
        readme 'AFTER_INSTALL' if behavior == :invoke
      end
    end
  end
end
