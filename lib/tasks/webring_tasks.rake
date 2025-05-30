namespace :webring do
  desc 'Build Tailwind CSS for webring engine'
  task :build_css do
    engine_root = File.expand_path('../..', __dir__)
    config_path = File.join(engine_root, 'config', 'tailwind.config.js')
    input_path = File.join(engine_root, 'app', 'assets', 'stylesheets', 'webring', 'application.css')
    output_path = File.join(engine_root, 'app', 'assets', 'builds', 'webring', 'application.css')

    # Ensure the output directory exists
    FileUtils.mkdir_p(File.dirname(output_path))

    # Build the CSS
    system("tailwindcss -c #{config_path} -i #{input_path} -o #{output_path}")
  end

  desc 'Watch and rebuild Tailwind CSS for webring engine'
  task :watch_css do
    engine_root = File.expand_path('../..', __dir__)
    config_path = File.join(engine_root, 'config', 'tailwind.config.js')
    input_path = File.join(engine_root, 'app', 'assets', 'stylesheets', 'webring', 'application.css')
    output_path = File.join(engine_root, 'app', 'assets', 'builds', 'webring', 'application.css')

    # Ensure the output directory exists
    FileUtils.mkdir_p(File.dirname(output_path))

    # Watch and build the CSS
    system("tailwindcss -c #{config_path} -i #{input_path} -o #{output_path} --watch")
  end
end
