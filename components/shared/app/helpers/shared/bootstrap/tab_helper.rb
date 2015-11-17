module Shared::Bootstrap::TabHelper
  def tab_link_tag(title, tab, path, options = {})
    classes  = Hash.new
    defaults = { data: { toggle: :tab, state: true, target: "##{tab}" }}

    options = defaults.deep_merge(options)

    classes.merge! class: :active if params[:tab].to_sym == tab.to_sym

    content_tag :li, classes do
      block_given? ? yield(options) : link_to(title, path, options)
    end
  end

  def tab_link_tag_with_count(body, tab, path, count, options = {})
    tab_link_tag(body, tab, path, options) do |defaults|
      link_to_with_count(body, path, count, options.deep_merge(defaults))
    end
  end

  def tab_content_tag(tab, options = {}, &block)
    options.merge! id: tab
    options.merge! class: "tab-pane #{:active if params[:tab].to_sym == tab.to_sym}"

    content_tag :div, options, &block
  end

  def render_tab_content(partial, tab, options = {})
    locals = options.delete(:locals) || {}

    tab_content_tag tab, options do
      render partial.to_s, locals.merge(tab: tab)
    end
  end
end
