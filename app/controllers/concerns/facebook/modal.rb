module Facebook::Modal
  extend ActiveSupport::Concern

  included do
    before_action :show_facebook_modal
  end

  def show_facebook_modal
    if session[:facebook_modal] == nil
      binding.pry
      session[:facebook_modal] = true
    elsif session[:facebook_modal] == true
      binding.pry
      session[:facebook_modal] = false
    end
  end
end