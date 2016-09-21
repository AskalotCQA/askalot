module Shared::DeletablesHelper
  def link_to_deletable(deletable, body, url, options = {})
    delete = options.delete(:delete)

    if options.delete(:deleted) != false && deletable.deleted?
      return delete.call(body, url, options) if delete.is_a? Proc
      return content_tag :span, body, tooltip_attributes(t("#{deletable.class.name.demodulize.downcase}.deleted"), placement: :bottom).merge(options)
    end

    url = options[:current_user].default_askalot_page_url + '#' + url if options[:page_url_prefix] && options[:current_user]

    link_to body, url, options
  end
end
