module Shared
  module AdministrationHelper
    def administration_link_tag(title, tab, path, options = {})
      classes       = Hash.new
      is_tab        = params[:tab] && params[:tab].to_sym == tab.to_sym
      is_controller = params[:controller] && params[:controller].include?(tab.to_s)

      classes.merge! class: :active if is_tab || is_controller

      content_tag :li, classes do
        block_given? ? yield(options) : link_to(title, path, options)
      end
    end
  end
end