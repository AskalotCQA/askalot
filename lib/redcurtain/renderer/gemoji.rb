# TODO(zbell) try to drop ActionView dependency

require 'action_view/helpers/asset_tag_helper'
require 'action_view/helpers/asset_url_helper'

module Redcurtain::Renderer
  module Gemoji
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::AssetUrlHelper

    extend self

    def render(content, options = {})
      content.to_s.gsub(/:[a-z0-9\+\-_]+:/) { |match|
        name = match[1..-2]

        if Emoji.names.include? name
          image_tag(image_path("gemoji/#{name}.png"), class: :gemoji, alt: name)
        else
          match
        end
      }.html_safe
    end
  end
end
