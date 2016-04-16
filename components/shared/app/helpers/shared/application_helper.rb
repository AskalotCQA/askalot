module Shared
module ApplicationHelper
  include FontAwesome::Rails::IconHelper

  @@use_container = false

  def default_title
    'Askalot'
  end

  def resolve_sidebar(value)
    ' data-spy="scroll" data-target="#sidebar"'.html_safe if value.present?
  end

  def resolve_title(value)
    return default_title if value.blank?
    return title(value) unless value.end_with? default_title

    value
  end

  def title(*values)
    (values << default_title).map { |value| html_escape value }.join(' &middot; ').html_safe
  end

  def canonical_url
    "https://#{request.host}#{request.fullpath}"
  end

  def url_to_site(path = nil)
    File.join(Shared::Configuration.url.site, path.to_s)
  end

  def url_to_organization(path = nil)
    File.join(Shared::Configuration.url.organization, path.to_s).sub(/\/\z/, '')
  end

  def url_to_repository(path = nil)
    url_to_organization "askalot/#{path}"
  end

  def use_container(value)
    @@use_container = value
  end

  def use_container?
    @@use_container || [DeviseController, ErrorsController, Shared::StaticPagesController].inject(true) { |result, type| result &&= !controller.is_a?(type) }
  end
end
end
