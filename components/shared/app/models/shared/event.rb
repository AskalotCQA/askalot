module Shared
class Event < ActiveRecord::Base
  validates :data, presence: true

  self.table_name = 'events'

  def data
    read_attribute(:data).deep_symbolize_keys
  end
end
end
