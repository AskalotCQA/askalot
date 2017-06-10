module Shared::StatisticsHelper
  def mean(values)
    values.sum.to_f / values.count
  end

  def median(values)
    values, count = values.sort, values.count

    (values[(count - 1) / 2] + values[count / 2]) / 2.0
  end

  def mean_and_standard_deviation(values)
    mean = mean(values)
    sum  = values.inject(0) { |a, i| a + (i - mean) ** 2 }

    return mean, Math.sqrt(sum / (values.count - 1)).to_f
  end

  def min(values)
    values.min
  end

  def max(values)
    values.max
  end


  def data_fraction_tag(numeration, denomination)
    content_tag(:td, numeration.size, class: :'text-right') +
    content_tag(:td, denomination.size != 0 ? number_to_percentage(100 * numeration.size / denomination.size.to_f, precision: 2) : :'?%', class: :'text-right')
  end

  def data_description_tag(values)
    if values.any?
      min   = min(values)
      mean  = mean(values)
      max   = max (values)
    else
      min = mean = max = :'?'
    end

    content_tag(:td, min, class: :'text-right') +
    content_tag(:td, number_with_precision(mean, precision: 2), class: :'text-right') +
    content_tag(:td, max, class: :'text-right')
  end

  def data_tag(value, options = {})
    classes = Array.wrap options[:class]

    if block_given?
      data    = yield value, options
      value   = data.first
      classes = Array.wrap(data.second)
    else
      classes << :'text-muted' if value.zero?
      classes << :'text-right'
    end

    content_tag :td, value, options.merge(class: classes.reject(&:blank?))
  end
end
