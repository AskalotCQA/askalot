module Shared::DashboardHelper
  def dashboard_link(icon, number, description, path)
    html = <<-HTML
      <div class="col-xs-6">
        <a href="#{path}">
          <div class="link-icon">#{fa_icon icon}</div>
          <div class="link-text">
            <div class="number">#{number}</div>
            <div class="description">#{description}</div>
          </div>
        </a>
      </div>
    HTML

    html.html_safe
  end

end
