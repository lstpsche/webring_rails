require_relative 'lib/webring/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.2.3'

  spec.name        = 'webring-rails'
  spec.version     = Webring::VERSION
  spec.authors     = ['Nikita Shkoda']
  spec.email       = ['lstpsche@gmail.com']
  spec.homepage    = 'https://github.com/lstpsche/webring_rails'
  spec.summary     = 'WebRing plugin for Rails'
  spec.description = 'Mountable Rails Engine for webring implementation with an embeddable styled widget'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  # spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'README.md']
  end

  spec.add_dependency 'rails', '~> 8.0'

  spec.add_development_dependency 'rubocop', '~> 1.75'
  spec.add_development_dependency 'rubocop-rails', '~> 2.31'
end
