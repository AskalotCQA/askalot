module Orderable
  extend ActiveSupport::Concern

  included do
    scope :order_by, lambda { |params|
      # TODO use nonumeric data
      # TODO allow other attributes
      raise ArgumentError.new("Currently, only numeric data are allowed.") unless params.values.flatten.map(&:class).uniq == [Fixnum]

      params.inject(self) do |relation, (attribute, values)|
        array     = values.map { |value| value.to_i }.join(',')
        attribute = attribute.to_s.gsub(/[^a-zA-Z0-9\.\_]/, '')

        relation.order("array_idx(ARRAY[#{array}], #{attribute})")
      end
    }
  end
end
