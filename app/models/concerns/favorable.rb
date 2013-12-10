module Favorable
  extend ActiveSupport::Concern

  included do
    has_many :favorites
    has_many :favorers, through: :favorites, source: :user
  end
end
