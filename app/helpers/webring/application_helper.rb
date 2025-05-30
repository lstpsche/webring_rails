module Webring
  module ApplicationHelper
    # Returns the full URL to the widget JavaScript file
    # This helps with proper URL generation in the widget instructions
    def widget_url(format: 'js')
      webring.widget_path(format: format, host: request.base_url)
    end
  end
end
