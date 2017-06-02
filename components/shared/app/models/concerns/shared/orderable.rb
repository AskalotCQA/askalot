module Shared::Orderable
  extend ActiveSupport::Concern

  included do
    scope :order_by, lambda { |params|
      # TODO use nonumeric data
      # TODO allow other attributes
      types = params.values.flatten.map(&:class).uniq

      raise ArgumentError.new('Only numeric data allowed') unless types.empty? || types == [Integer]

      params.inject(self) do |relation, (attribute, values)|
        next if values.empty?

        array     = values.map { |value| value.to_i }.join(',')
        attribute = attribute.to_s.gsub(/[^a-zA-Z0-9\.\_]/, '')

        relation.order("array_idx(ARRAY[#{array}], #{attribute})")
      end
    }
  end
end
