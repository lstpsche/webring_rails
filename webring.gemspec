require_relative 'lib/webring/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.2.3'

  spec.name        = 'webring_rails'
  spec.version     = Webring::VERSION
  spec.authors     = ['Nikita Shkoda (Silivonchik)']
  spec.email       = ['lstpsche@gmail.com']
  spec.homepage    = 'https://github.com/lstpsche/webring_rails'
  spec.summary     = 'WebRing plugin for Rails'
  spec.description = 'Mountable Rails Engine for webring implementation'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/lstpsche/webring_rails'
  # spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'propshaft', '>= 0.9', '< 2.0'
  spec.add_dependency 'rails', '>= 7.0'

  spec.add_development_dependency 'rubocop', '~> 1.75'
  spec.add_development_dependency 'rubocop-rails', '~> 2.31'
end
