module Webring
  class WidgetController < ::ApplicationController
    # Disable CSRF protection for widget.js as it needs to be loaded from other domains
    skip_forgery_protection only: :show

    # Set CORS headers for the widget
    before_action :set_cors_headers, only: :show

    # Serve the webring navigation widget JavaScript
    # GET /webring/widget.js
    def show
      respond_to do |format|
        format.js do
          response.headers['Content-Type'] = 'application/javascript'

          # Serve the JavaScript file from the engine's assets
          render file: Webring::Engine.root.join('app/assets/javascripts/webring/widget.js')
        end
      end
    end

    private

    def set_cors_headers
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
      response.headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept'
      response.headers['Access-Control-Max-Age'] = '86400'
    end
  end
end
