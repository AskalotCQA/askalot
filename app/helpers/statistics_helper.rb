module StatisticsHelper
  def statistical_cell(value, options = {})
    options = options.reverse_merge(negative: :danger, zero: :'text-muted', positive: nil)
    classes = Array.wrap options[:class]

    classes << options.delete(:negative) if value < 0
    classes << options.delete(:zero)     if value.zero?
    classes << options.delete(:positive) if value > 0

    content_tag :td, value, options.merge(class: classes)
  end
end
