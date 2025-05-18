module Webring
  class WidgetController < ApplicationController
    # Disable CSRF protection for widget.js as it needs to be loaded from other domains
    skip_forgery_protection only: :show

    # Serve the webring navigation widget JavaScript
    # GET /webring/widget.js
    def show
      respond_to do |format|
        format.js do
          # Set proper content type for JavaScript
          response.headers['Content-Type'] = 'application/javascript'

          # Serve the JavaScript file
          render file: Engine.root.join('app', 'assets', 'javascripts', 'webring', 'widget.js')
        end
      end
    end
  end
end
