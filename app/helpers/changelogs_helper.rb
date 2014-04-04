module ChangelogsHelper
  def group_changelogs_by_latest(changelogs)
    Hash[group_changelogs_by_version(changelogs).map { |_, changelogs|
      [changelogs.first, changelogs - [changelogs.first]]
    }]
  end

  def group_changelogs_by_version(changelogs)
    changelogs.inject(Hash.new { |h, k| h[k] = [] }) do |groups, changelog|
      prefix = changelog.version.match(/\d+\.\d+/)[0] || :unknown

      groups[prefix.to_sym] << changelog
      groups
    end
  end
end
