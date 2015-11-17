module University::Applications::Tab
  extend ActiveSupport::Concern

  module ClassMethods
    def default_tab(value, options = {})
      before_action options do
        params[:tab] ||= value
      end
    end
  end

  def tab_page(tab, default = 1)
    params[:tab].to_sym == tab.to_sym ? params[:page] : default
  end
end
