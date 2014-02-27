class Changelog < ActiveRecord::Base
  validates :title,   presence: true
  validates :text,    presence: true
  validates :version, presence: true, uniqueness: true
end
