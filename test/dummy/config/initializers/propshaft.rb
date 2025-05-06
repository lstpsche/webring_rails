# Configure Propshaft for asset handling

# Configure the asset load paths
Rails.application.config.asset_app = Propshaft::Assembly.new(
  load_path: [
    # Add your asset paths here
    Rails.root.join('app/assets'),
    Rails.root.join('vendor/assets'),

    # Add the engine's assets
    Webring::Engine.root.join('app/assets')
  ],
  prefix: '/assets'
)

# Configure the asset URL host in production
if Rails.env.production?
  # Set your asset host in production environments
  # Rails.application.config.asset_app.config.host = "https://cdn.example.org"
end
