module Webring
  module Generators
    class WebringGenerator < Rails::Generators::NamedBase
      namespace 'webring'

      desc 'Creates a Webring configuration for the given model name'

      def invoke_webring_member
        invoke 'webring:member'
      end

      def invoke_webring_controller
        invoke 'webring:controller'
      end
    end
  end
end
