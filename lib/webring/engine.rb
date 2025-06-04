module Webring
  class Engine < ::Rails::Engine
    isolate_namespace Webring

    # Add concerns to autoload paths
    initializer 'webring.autoload_paths' do |app|
      app.config.autoload_paths += %W[#{config.root}/app/models/concerns]
    end

    # configure app generators for templates
    config.app_generators do |g|
      g.templates.unshift File.expand_path('../../generators/webring/templates', __dir__)
    end

    # load generators properly for Rails compatibility
    initializer 'webring.load_generators' do |app|
      generators_path = File.expand_path('../../generators', __dir__)

      # add generators path to Rails paths
      if defined?(Rails.application.config.generators.templates)
        Rails.application.config.generators.templates.unshift(File.join(generators_path, 'webring/templates'))
      end

      # ensure the generators path exists in the app's paths
      if app.config.respond_to?(:paths)
        app.config.paths['lib/generators'] ||= []
        app.config.paths['lib/generators'] << generators_path
      end
    end

    # add migrations from the engine to the main app
    initializer 'webring.append_migrations' do |app|
      unless app.root.to_s == root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end
  end
end
