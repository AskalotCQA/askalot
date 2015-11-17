module University::Facebook::Modal
  extend ActiveSupport::Concern

  included do
    after_action :show_facebook_modal
  end

  def show_facebook_modal
    if current_user
      if session[:facebook_modal] == nil
        session[:facebook_modal] = true
      elsif session[:facebook_modal] == true
        session[:facebook_modal] = false
      end
    end
  end
end
