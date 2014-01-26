class Tag < ActiveRecord::Base
  include Watchable

  attr_accessor :count

  has_many :taggings

  before_save :normalize

  def normalize
    self.name = name.to_s.downcase.gsub(/[^[:alnum:]]+/, '-').gsub(/\A-|-\z/, '')
  end
end
