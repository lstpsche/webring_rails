module Webring
  class WidgetController < ::ApplicationController
    # Disable CSRF protection for widget.js as it needs to be loaded from other domains
    skip_forgery_protection

    # Set CORS headers for the widget
    before_action :set_cors_headers

    # Serve the webring navigation widget JavaScript
    # GET /webring/widget.js
    def show
      respond_to do |format|
        format.js do
          response.headers['Content-Type'] = 'application/javascript'

          # Take the JavaScript file from the engine's assets and replace the customizable Logo SVG
          widget_js =
            Webring::Engine
            .root.join('app/assets/javascripts/webring/widget.js')
            .read
            .gsub('<<REPLACE_ME_LOGO_SVG>>', logo_svg)

          render js: widget_js
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

    # should include `${width}`, `${height}`, `${style}` in order to be customizable
    def logo_svg
      <<~SVG
        <svg width="${width}" height="${height}" style="${style}" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M13 3L6 14H12L11 21L18 10H12L13 3Z" fill="currentColor"/>
        </svg>
      SVG
    end
  end
end
