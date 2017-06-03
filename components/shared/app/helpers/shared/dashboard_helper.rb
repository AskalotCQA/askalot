module Shared::DashboardHelper
  def dashboard_link(icon, number, description, path, type)
    html = <<-HTML
      <div class="col-xs-4">
        <a href="#{path}">
          <div class="link-icon #{type}">#{fa_icon icon}</div>
          <div class="link-text">
              <div class="vertical-table">
                <div class="vertical-cell">
                  <span class="number">#{number}</span>
                  <span class="description">#{description}</span>
                </div>
              </div>
          </div>
        </a>
      </div>
    HTML

    html.html_safe
  end

  def active_tab_class(user, tab)
    if tab == :activites
      return 'active'
    end

    return ''
  end
end
