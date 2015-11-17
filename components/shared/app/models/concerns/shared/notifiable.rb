module Shared::Notifiable
  extend ActiveSupport::Concern

  included do
    has_many :activities, as: :resource, dependent: :destroy
    has_many :notifications, as: :resource, dependent: :destroy
  end
end
