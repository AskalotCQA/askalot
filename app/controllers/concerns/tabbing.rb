module Tabbing
  extend ActiveSupport::Concern

  def set_default_tab
    params[:tab] ||= self.class.default_tab
  end

  module ClassMethods
    def default_tab(value = nil, options = {})
      return @default_tab unless value

      @default_tab = value

      before_action :set_default_tab, options
    end
  end
end
