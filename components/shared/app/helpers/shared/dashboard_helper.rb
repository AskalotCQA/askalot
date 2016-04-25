module Shared::DashboardHelper
  def dashboard_link(icon, number, description, path, type)
    html = <<-HTML
      <div class="col-lg-6 col-md-12 col-sm-6 col-xs-12">
        <a href="#{path}">
          <div class="link-icon #{type}">#{fa_icon icon}</div>
          <div class="link-text">
            <div class="number">#{number}</div>
            <div class="description">#{description}</div>
          </div>
        </a>
      </div>
    HTML

    html.html_safe
  end

  def active_tab_class(news, user, tab)
    if user.dashboard_last_sign_in_at < news.first.created_at
      if tab == :news
        return 'active'
      end
    else
      if tab == :activites
        return 'active'
      end
    end
    return ''
  end

end
