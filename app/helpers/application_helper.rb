module ApplicationHelper
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
    "http://#{request.host}#{request.fullpath}"
  end

  def url_to_site(path = nil)
    File.join 'http://labss2.fiit.stuba.sk/TeamProject/2013/team13is-si/', path.to_s
  end

  def url_to_organization(path = nil)
    File.join('https://github.com/teamnaruby/', path.to_s).sub(/\/\z/, '')
  end

  def url_to_repository(path = nil)
    url_to_organization "askalot/#{path}"
  end

  def use_container?
    [DeviseController, ErrorsController, StaticPagesController].inject(true) { |result, type| result &&= !controller.is_a?(type) }
  end
end
