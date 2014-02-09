module ApplicationHelper
  def default_title
    'Askalot'
  end

  def resolve_title(value)
    return default_title if value.blank?
    return title(value) unless value.end_with? default_title

    value
  end

  def title(*values)
    (values << default_title).map { |value| html_escape value }.join(' &middot; ').html_safe
  end

  def use_container?
    params[:controller] != 'errors'
  end

  def use_narrower_layout?
    devise_controller? && !current_page?(edit_user_registration_path) && !(params[:controller] == 'registrations' && params[:action] == 'update')
  end

  def url_to_site(path = nil)
    "http://labss2.fiit.stuba.sk/TeamProject/2013/team13is-si/#{path}"
  end
end
