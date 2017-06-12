module Shared::DeletablesHelper
  def link_to_deletable(deletable, body, url, options = {})
    if options.delete(:deleted) != false && deletable.deleted?
      options.delete(:mute)
      return content_tag :span, body, tooltip_attributes(t("#{deletable.class.name.demodulize.downcase}.deleted"), placement: :top).merge(options)
    end

    url = options[:current_user].default_askalot_page_url + '#' + url if options[:page_url_prefix] && options[:current_user]

    link_to body, url, options
  end
end
