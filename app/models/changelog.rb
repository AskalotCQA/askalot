class Changelog < ActiveRecord::Base
  validates :text, presence: true
end
