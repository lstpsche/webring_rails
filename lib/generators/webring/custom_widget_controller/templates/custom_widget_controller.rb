module Webring
  class CustomWidgetController < Webring::WidgetController
    private

    # should include `${width}`, `${height}`, `${style}` in order to be customizable
    # remove the method or call `super` to use the default logo
    def logo_svg
      <<~HTML
        Add your custom logo SVG here
      HTML
    end

    # Override default texts for the widget
    # Remove the method or call `super` to use the gem's default texts
    def text_defaults
      {
        prev: { default: 'Prev', enforced: false },
        random: { default: 'Random', enforced: false },
        next: { default: 'Next', enforced: false },
        widgetTitle: { default: 'Webring', enforced: false }
      }
    end
  end
end
