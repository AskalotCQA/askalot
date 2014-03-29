module Notifiable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :resource, dependent: :destroy
  end
end
