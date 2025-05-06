# Webring Rails

A Ruby on Rails engine that allows you to create and manage a webring for your community.
Webrings are a way to connect related websites together in a circular chain, allowing visitors to navigate between member sites.

## Features

- Easy integration with any Rails application
- Simple API for adding and removing sites from your webring
- Customizable navigation widgets
- Admin interface for managing webring members
- Support for multiple webrings within a single application

## Installation

Add this line to your application's Gemfile:

```ruby
gem "webring_rails"
```

And then execute:

```bash
bundle
```

Run the generator to install the necessary files:

```bash
rails generate webring:install
```

This will create a new migration to add the `webring_members` table to your database.

```bash
rails db:migrate
```
