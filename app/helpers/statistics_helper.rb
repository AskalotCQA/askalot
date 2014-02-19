module StatisticsHelper
  def statistical_cell(value, options = {}, &block)
    classes = Array.wrap options[:class]

    unless block_given?
      map = {
        negative: options.delete(:negative) || :danger,
        zero:     options.delete(:zero) || :'text-muted',
        positive: options.delete(:positive)
      }

      classes << map[:negative] if value < 0
      classes << map[:zero]     if value.zero?
      classes << map[:positive] if value > 0
      classes << "text-#{classes.last}" unless classes.last.blank? || classes.last.to_s.start_with?('text')
      classes << :'text-right'
    else
      data = block.call(value, options)

      if data.is_a? Array
        value, classes = data.first, Array.wrap(data.second)
      elsif data.is_a? Hash
        value, classes = data[:value], Array.wrap(data[:class])
      else
        classes += Array.wrap data
      end
    end

    content_tag :td, value, options.merge(class: classes.reject(&:blank?))
  end
end
