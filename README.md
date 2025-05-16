# WebringRails

A Rails engine for creating and managing a webring.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Generators](#generators)
    - [Installation Generator](#installation-generator)
    - [Member Model Generator](#member-model-generator)
    - [Navigation Controller Generator](#navigation-controller-generator)
- [Models](#models)
  - [Webring::Member](#webringmember)
- [Modules](#modules)
  - [Webring::Navigation](#webringnavigation)
    - [Key Features](#key-features)
    - [Available Methods](#available-methods)
    - [Usage in Models](#usage-in-models)
    - [Implementation Example](#implementation-example)
    - [Customizing Navigation Behavior](#customizing-navigation-behavior)
- [Controllers](#controllers)
  - [Webring::NavigationController](#webringnavigationcontroller)
    - [How to Use the Navigation Controller](#how-to-use-the-navigation-controller)
    - [Customizing Navigation Behavior](#customizing-navigation-behavior-1)
  - [Webring::MembersController](#webringmemberscontroller)
- [Development](#development)
  - [Migrations](#migrations)
  - [Tailwind CSS Integration](#tailwind-css-integration)
  - [Testing](#testing)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'webring_rails'
```

Then execute:
```bash
$ bundle install
```

Run the installation generator:

```bash
$ rails generate webring:install
```

This will mount the engine in your routes.

## Usage

### Generators

WebringRails provides several generators to help you set up webring functionality in your application.

#### Installation Generator

```bash
$ rails generate webring:install
```

This generator:
- Mounts the Webring engine in your routes.rb

#### Member Model Generator

```bash
$ rails generate webring:member
```

This generator:
- Creates the Webring::Member model with name and url fields
- Creates a migration for the members table
- Adds member routes to your routes.rb file

#### Navigation Controller Generator

```bash
$ rails generate webring:controller
```

This generator:
- Creates the Webring::NavigationController with '/next', '/previous', and '/random' actions
- Adds navigation routes to your routes.rb file

## Models

### Webring::Member

The Member model includes:

- Validations for presence and uniqueness of `url` and uniqueness of `name`
- Automatic population of `name` from `url` if name is not provided
- Navigation methods for finding next, previous, and random members:
  - `find_next(source_member_id)` - Finds the next member after the given ID
  - `find_previous(source_member_id)` - Finds the previous member before the given ID
  - `find_random(source_member_id: nil)` - Finds a random member, excluding the source member

## Modules

### Webring::Navigation

The Navigation module provides methods for navigating through members in a webring pattern. It's designed to be extended by models that act as webring members.

#### Key Features

- **Webring-style navigation**: Implements the circular navigation pattern typical of webrings
- **ID-based member ordering**: Uses database IDs to determine the sequence of members
- **Edge case handling**: Properly handles wraparound at the beginning and end of the ring

#### Available Methods

The module provides three core methods:

- `find_next(source_member_id)`: Finds the next member in the ring after the specified member
  - If the source member is the last in the ring, it returns the first member
  - Uses descending ID order for navigation

- `find_previous(source_member_id)`: Finds the previous member in the ring before the specified member
  - If the source member is the first in the ring, it returns the last member
  - Uses ascending ID order for navigation

- `find_random(source_member_id: nil)`: Finds a random member in the ring
  - If a source member ID is provided, it excludes that member from the selection
  - If the source member is the only one in the ring, it returns that same member

#### Usage in Models

The module is designed to be extended in your model:

```ruby
class YourMember < ApplicationRecord
  extend Webring::Navigation

  # Your model code...
end
```

#### Implementation Example

The `Webring::Member` model extends the Navigation module:

```ruby
module Webring
  class Member < ApplicationRecord
    extend Webring::Navigation

    # Member model implementation...
  end
end
```

This allows you to call navigation methods on the class:

```ruby
# Find the next member after member with ID 5
next_member = Webring::Member.find_next(5)

# Find the previous member before member with ID 5
previous_member = Webring::Member.find_previous(5)

# Find a random member (excluding member with ID 5)
random_member = Webring::Member.find_random(source_member_id: 5)
```

#### Customizing Navigation Behavior

You can override the default navigation behavior by creating your own module that includes or extends the Webring::Navigation module:

```ruby
module YourApp
  module CustomNavigation
    include Webring::Navigation

    # Override methods as needed
    def find_next(source_member_id)
      # Custom implementation for finding the next member
      # For example, you might want to order by name instead of ID
      where('name > ?', find_by(id: source_member_id)&.name)
        .order(:name)
        .first || order(:name).first
    end
  end
end
```

Then apply your custom navigation module to your model:

```ruby
class YourMember < ApplicationRecord
  extend YourApp::CustomNavigation

  # Your model code...
end
```

**Note**: The Navigation module requires models to have an `id` column for its default implementation.

## Controllers

### Webring::NavigationController

Navigation controller manages the webring navigation flow for end users visiting member sites:

- `next` - Redirects to the next member in the webring
- `previous` - Redirects to the previous member in the webring
- `random` - Redirects to a random member in the webring

This controller handles requests that come directly from webring members' sites. When a user clicks a navigation button on a webring widget (displayed on a member's site), the request is sent to this controller with the current member's ID. The controller then determines the appropriate member to navigate to and redirects the user to that member's URL.

#### How to Use the Navigation Controller

To use the navigation controller in your webring implementation, you need to include navigation links on each member's website. These links should point to your application's navigation routes with the `source_member_id` parameter.

Example HTML for your webring widget:

```html
<div class="webring-widget">
  <p>This site is part of a webring</p>
  <nav>
    <a href="https://your-app.com/webring/previous?source_member_id=123">← Previous</a>
    <a href="https://your-app.com/webring/random?source_member_id=123">Random</a>
    <a href="https://your-app.com/webring/next?source_member_id=123">Next →</a>
  </nav>
</div>
```

Replace `123` with the actual member ID and `https://your-app.com` with your application's domain.

The controller handles several cases:
- If the source member ID is invalid or not found, it returns a 404 "Member not found" response
- If there are no members in the webring, it returns a 404 "No members in the webring" response
- For `next` and `previous` actions, if the current member is the last or first respectively, it wraps around to the other end of the ring
- For `random` action, it ensures the random member is not the same as the source member (unless there's only one member)

#### Customizing Navigation Behavior

If you want to customize the navigation behavior, you can create your own controller that inherits from the default navigation controller:

```ruby
# app/controllers/my_navigation_controller.rb
class MyNavigationController < Webring::NavigationController
  # Override methods and call super if needed
  def next
    # Your custom logic before default behavior
    super
    # `super` will redirect to member.url, so no code will be executed after this
  end

  def previous
    # Completely custom implementation
    @previous_member = Webring::Member.find_previous(params[:source_member_id])
    redirect_to @previous_member.url, allow_other_host: true
  end
end
```

Then update your routes to use your custom controller:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # ... other routes ...

  # Override default webring routes with your custom controller
  get 'webring/next', to: 'my_navigation#next'
  get 'webring/previous', to: 'my_navigation#previous'
  get 'webring/random', to: 'my_navigation#random'
end
```

### Webring::MembersController

Members controller provides full CRUD functionality for managing webring members:

- `index` - Lists all webring members
- `show` - Displays details for a specific member
- `new` - Form for creating a new member
- `create` - Creates a new webring member
- `edit` - Form for editing an existing member
- `update` - Updates an existing webring member
- `destroy` - Deletes a webring member

This controller is primarily designed for administrative purposes and will be used by the admin panel to manage webring membership.

## Development

To set up the development environment:

1. Clone this repository
2. Run `bundle install`
3. Run `bin/setup_dummy` to prepare the test dummy app

### Migrations

After creating a new migration in the engine, you need to run:
```bash
cd test/dummy
bin/rails db:migrate
```
Which will run the migrations in the dummy app.
You don't need to copy migrations to the dummy app, it looks for them in the engine.

### Tailwind CSS Integration

This gem includes Tailwind CSS via CDN for simplicity and ease of use. There's no build process required - the CDN automatically handles:

1. Loading the latest version of Tailwind CSS
2. Just-in-time compilation of styles
3. The Tailwind Forms plugin for enhanced form styling

The CDN approach provides several benefits:
- No build pipeline required
- Smaller bundle size for development
- Quick prototyping and development experience

The implementation can be found in the application layout file:

```erb
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/forms@0.5.7/dist/cdn.min.js"></script>
<script>
  tailwind.config = {
    theme: {
      extend: {}
    },
    plugins: [
      tailwindForms
    ]
  }
</script>
```

### Testing

As of now, there are no tests.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
