# WebringRails

A Rails engine for creating and managing a webring.

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

## Controllers

### Webring::NavigationController

Navigation controller manages the webring navigation flow for end users visiting member sites:

- `next` - Redirects to the next member in the webring
- `previous` - Redirects to the previous member in the webring
- `random` - Redirects to a random member in the webring

This controller handles requests that come directly from webring members' sites. When a user clicks a navigation button on a webring widget (displayed on a member's site), the request is sent to this controller with the current member's ID. The controller then determines the appropriate member to navigate to and redirects the user to that member's URL.

#### Customizing Navigation Behavior

If you want to customize the navigation behavior, you can create your own controller that inherits from the default navigation controller:

```ruby
# app/controllers/my_navigation_controller.rb
class MyNavigationController < Webring::NavigationController
  # Override methods and call super if needed
  def next
    # Your custom logic before default behavior
    super
    # Your custom logic after default behavior
  end

  def previous
    # Completely custom implementation
    @previous_member = Webring::Member.where("id < ?", params[:current_id]).last
    redirect_to @previous_member.url
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
