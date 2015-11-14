# See https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide

module AnalyticsHelper
  def analytics_attributes(category, action, label = nil, options = {})
    category = category.to_s.downcase

    action, label = *[action, label].map { |s| Array.wrap(s).map(&:to_s).join(' - ').downcase }

    data = { :'track-category' => category, :'track-action' => action, :'track-label' => label }

    options.deep_merge data: data.reject { |_, value| value.blank? }
  end
end
