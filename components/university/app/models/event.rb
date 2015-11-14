class Event < ActiveRecord::Base
  validates :data, presence: true

  def data
    read_attribute(:data).deep_symbolize_keys
  end
end
