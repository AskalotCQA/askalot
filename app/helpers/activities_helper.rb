module ActivitiesHelper
  #TODO(zbell) as long as private scope of activities is wider than
  # notifications reverse method calls, e.g. notification helpers call
  # activity helpers internally (not vice versa as it is now)

  def activity_icon_tag(activity, options = {})
    notification_icon_tag activity, options.merge(mute: lambda { |_| false })
  end

  def activity_content(activity, options = {})
    notification_content activity, options.merge(mute: lambda { |_| false }, url: lambda { |url| url })
  end
end
