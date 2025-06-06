![Webring Widget Sample](widget-sample.jpeg)

# Webring for Rails

Webring for Rails (webring_rails) is a flexible engine for creating and managing a webring system in your Ruby on Rails application. A webring is a collection of websites linked together in a circular structure, allowing visitors to navigate from one site to another.

## Features

- Complete MVC structure for managing webring members
- Circular navigation system between member websites
- UID-based member identification for security
- Embeddable JavaScript widget for easy member site integration
- Customizable widget appearance and behavior
- Optional membership request system for sites to apply to join the webring
- Generators for easy setup and customization
- Extensible architecture for adding custom features

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'webring_rails'
```

Run:

```bash
# Install the gem
bundle install

# Run the installation generator
rails generate webring:install

# Create the member model and migrations
rails generate webring:member

# Create the navigation controller
rails generate webring:controller:navigation
```

### Optional Features

```bash
# Enable the membership request system
rails generate webring:membership_request

# Add membership request controller and routes
rails generate webring:controller:membership_requests
```

Finally, run the migrations:

```bash
rails db:migrate
```

## Documentation

For detailed documentation on models, controllers, modules, widget customization, and more advanced installation options, please visit the [Webring Rails Wiki](https://github.com/lstpsche/webring-rails/wiki).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
