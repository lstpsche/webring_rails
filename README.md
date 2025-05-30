# Webring for Rails

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
bundle install
```

Run the installation generator:

```bash
rails generate webring:install
```

> [!TIP]
> The installation generator will automatically mount the engine in your routes.rb file, making it ready to use.

## Usage

### Generators

WebringRails provides several generators to help you set up webring functionality in your application.

> [!IMPORTANT]
> Make sure to run the generators in the order listed below for the best setup experience.

#### Installation Generator

```bash
rails generate webring:install
```

This generator:
- Mounts the Webring engine in your routes.rb

#### Member Model Generator

```bash
rails generate webring:member
```

This generator:
- Creates the Webring::Member model with uid, name and url fields
- Creates a migration for the members table
- Adds member routes to your routes.rb file

#### Navigation Controller Generator

```bash
rails generate webring:controller
```

This generator:
- Creates the Webring::NavigationController with '/next', '/previous', and '/random' actions
- Adds navigation routes to your routes.rb file

## Models

### Webring::Member

> [!NOTE]
> The Member model is the core component of your webring, representing each site in the ring.

The Member model includes:

- Validations for presence and uniqueness of `url`, uniqueness of `name`, and presence and uniqueness of `uid`
- Automatic generation of unique UID (32-character hex string) for each member
- Automatic population of `name` from `url` if name is not provided
- Navigation methods for finding next, previous, and random members:
  - `find_next(source_member_uid)` - Finds the next member after the given UID
  - `find_previous(source_member_uid)` - Finds the previous member before the given UID
  - `find_random(source_member_uid: nil)` - Finds a random member, excluding the source member

## Modules

### Webring::Navigation

> [!TIP]
> The Navigation module is designed to be highly extensible. You can easily override its methods to customize the navigation behavior for your specific needs.

The Navigation module provides methods for navigating through members in a webring pattern. It's designed to be extended by models that act as webring members.

#### Key Features

- **Webring-style navigation**: Implements the circular navigation pattern typical of webrings
- **UID-based member identification**: Uses unique identifiers instead of numeric IDs for security
- **Creation time ordering**: Uses `created_at` timestamps to determine the sequence of members
- **Edge case handling**: Properly handles wraparound at the beginning and end of the ring

#### Available Methods

The module provides three core methods:

- `find_next(source_member_uid)`: Finds the next member in the ring after the specified member
  - If the source member is the last in the ring, it returns the first member
  - Uses creation time for navigation ordering

- `find_previous(source_member_uid)`: Finds the previous member in the ring before the specified member
  - If the source member is the first in the ring, it returns the last member
  - Uses creation time for navigation ordering

- `find_random(source_member_uid: nil)`: Finds a random member in the ring
  - If a source member UID is provided, it excludes that member from the selection
  - If the source member is the only one in the ring, it returns that same member

#### Usage in Models

> [!WARNING]
> Make sure your model has `uid` and `created_at` columns before extending the Navigation module, as they're required for the default implementation.

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
# Find the next member after member with UID 'abc123...'
next_member = Webring::Member.find_next('abc123...')

# Find the previous member before member with UID 'abc123...'
previous_member = Webring::Member.find_previous('abc123...')

# Find a random member (excluding member with UID 'abc123...')
random_member = Webring::Member.find_random(source_member_uid: 'abc123...')
```

#### Customizing Navigation Behavior

You can override the default navigation behavior by creating your own module that includes or extends the Webring::Navigation module:

```ruby
module YourApp
  module CustomNavigation
    include Webring::Navigation

    # Override methods as needed
    def find_next(source_member_uid)
      # Custom implementation for finding the next member
      # For example, you might want to order by name instead of created_at
      source_member = find_by(uid: source_member_uid)
      return order(:name).first unless source_member

      where('name > ?', source_member.name)
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

**Note**: The Navigation module requires models to have `uid` and `created_at` columns for its default implementation.

## Controllers

### Webring::NavigationController

> [!IMPORTANT]
> The Navigation controller is responsible for handling all webring navigation requests and redirecting users between member sites.

Navigation controller manages the webring navigation flow for end users visiting member sites:

- `next` - Redirects to the next member in the webring
- `previous` - Redirects to the previous member in the webring
- `random` - Redirects to a random member in the webring

This controller handles requests that come directly from webring members' sites. When a user clicks a navigation button on a webring widget (displayed on a member's site), the request is sent to this controller with the current member's UID. The controller then determines the appropriate member to navigate to and redirects the user to that member's URL.

#### How to Use the Navigation Controller

To use the navigation controller in your webring implementation, you need to include navigation links on each member's website. These links should point to your application's navigation routes with the `source_member_uid` parameter.

Example HTML for your webring widget:

```html
<div class="webring-widget">
  <p>This site is part of a webring</p>
  <nav>
    <a href="https://your-app.com/webring/previous?source_member_uid=abc123...">← Previous</a>
    <a href="https://your-app.com/webring/random?source_member_uid=abc123...">Random</a>
    <a href="https://your-app.com/webring/next?source_member_uid=abc123...">Next →</a>
  </nav>
</div>
```

Replace `abc123...` with the actual member UID and `https://your-app.com` with your application's domain.

The controller handles several cases:
- If the source member UID is invalid or not found, it returns a 404 "Member not found" response
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
    @previous_member = Webring::Member.find_previous(params[:source_member_uid])
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

This gem integrates with Tailwind CSS using the `tailwindcss-rails` gem for optimal performance and development experience. The setup includes:

#### Gem Dependencies

The gem includes `tailwindcss-rails` as a dependency, which provides:
- Built-in Tailwind CSS compilation
- Watch mode for development
- Optimized builds for production
- Automatic purging of unused styles

#### Configuration

The Tailwind configuration is defined in `engines/webring_rails/config/tailwind.config.js`:

```javascript
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ]
}
```

This configuration ensures that Tailwind scans all relevant files in the engine for class usage and only includes the CSS for classes that are actually used.

#### Stylesheet Setup

The main stylesheet at `app/assets/stylesheets/webring/application.css` uses Tailwind directives:

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

#### Integration with Host Application

When using this gem in your Rails application, the Tailwind styles are automatically included when you include the engine's stylesheets. The compilation happens independently of the host application's asset pipeline, ensuring no conflicts.

For host applications that also use Tailwind CSS, both stylesheets can coexist without issues, as each maintains its own compilation process.

#### Benefits of This Approach

- **Performance**: Only includes CSS for classes actually used in the engine
- **Isolation**: No conflicts with host application's styling
- **Development Experience**: Automatic recompilation during development
- **Production Ready**: Optimized builds with proper purging

### Testing

> [!WARNING]
> As of now, there are no tests. Contributions to add test coverage are welcome!

## Widget Implementation

> [!TIP]
> The widget is a key feature that allows members to display webring navigation on their websites.

### Adding a Widget to Member's Site

Once a member is added to your webring, they need to include the widget on their site to enable navigation to other webring members. The widget is a JavaScript file that creates navigation links on the member's website.

#### Basic Implementation

To add the widget to a member's website, they need to:

1. Add the widget script to their HTML page
2. Include a container element with the specific ID

```html
<!-- Webring Widget -->
<script src="https://your-app-domain.com/webring/widget.js" data-member-uid="MEMBER_UID"></script>
<div id="webring-widget"></div>
<!-- End Webring Widget -->
```

Replace:
- `your-app-domain.com` with your application's actual domain
- `MEMBER_UID` with the unique identifier of the member in your webring

#### How the Widget Works

When added to a member's site, the widget:
1. Creates a small UI element with "Previous", "Random", and "Next" navigation links
2. The links point back to your webring hub application, passing the member's UID
3. When a visitor clicks a navigation link, they are redirected to another member's site
4. The navigation preserves the ring structure, allowing visitors to traverse through the entire webring

#### Widget Placement

Members should place the widget code in a visible area of their site, such as:
- The site footer
- A sidebar
- The about page
- Any area where they want to promote their webring membership

#### Customization Options

The default widget styling is minimal and should work with most websites. Members who want to customize the appearance can add their own CSS styles by targeting the `.webring-nav` CSS class.

#### Administration

From the webring administration interface, you can:
- View a preview of how the widget will look on a member's site
- Provide members with their personalized widget code when they're approved to join

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
