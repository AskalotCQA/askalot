module Tabbing
  extend ActiveSupport::Concern

  module ClassMethods
    def default_tab(value, options = {})
      before_action options do
        params[:tab] ||= value
      end
    end
  end
end
