module Webring
  class CustomWidgetController < Webring::WidgetController
    private

    # should include `${width}`, `${height}`, `${style}` in order to be customizable
    # remove the method or call `super` to use the default logo
    def logo_svg
      <<~SVG
        Add your custom logo SVG here
      SVG
    end
  end
end
