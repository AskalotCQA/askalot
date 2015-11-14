class Changelog < ActiveRecord::Base
  include Comparable

  validates :version, presence: true, uniqueness: true, version: true

  def <=>(changelog)
    -(self.to_version <=> changelog.to_version)
  end

  def identifier
    @identifier ||= version.gsub(/\./, '-')
  end

  def to_version
    @version ||= Gem::Version.create self.version
  end
end
