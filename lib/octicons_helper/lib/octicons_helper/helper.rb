require "octicons"
require "action_view"

module OcticonsHelper
  include ActionView::Helpers::TagHelper

  mattr_accessor :octicons_helper_cache, default: {}

  def octicon(symbol, options = {})
    return "" if symbol.nil?

    cache_key = [symbol, options]

    octicons_helper_cache ||= {} if Rails.version <= "5.2.3"
    
    if tag = octicons_helper_cache[cache_key]
      tag
    else
      icon = Octicons::Octicon.new(symbol, options)

      tag = content_tag(:svg, icon.path.html_safe, icon.options).freeze # rubocop:disable Rails/OutputSafety
      octicons_helper_cache[cache_key] = tag
      tag
    end
  end
end
