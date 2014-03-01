class Changelog < ActiveRecord::Base
  validates :title,   presence: true
  validates :text,    presence: true
  validates :version, presence: true, uniqueness: true

  def identifier
    @identifier ||= version.gsub(/\./, '-')
  end
end
