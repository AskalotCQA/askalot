class Changelog < ActiveRecord::Base
  validates :version, presence: true, uniqueness: true

  def identifier
    @identifier ||= version.gsub(/\./, '-')
  end
end
