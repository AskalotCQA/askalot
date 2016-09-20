module ActiveRecord
  module Validations
    class AssociatedBubblingValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        ((value.kind_of?(Enumerable) || value.kind_of?(ActiveRecord::Relation)) ? value : [value]).each do |v|
          unless v.valid?
            v.errors.full_messages.each do |msg|
              record.errors.add(attribute, msg, options.merge(:value => value)) unless msg.include? 'Attachment –'
            end
          end
        end
      end
    end

    module ClassMethods
      def validates_associated_bubbling(*attr_names)
        validates_with AssociatedBubblingValidator, _merge_attributes(attr_names)
      end
    end
  end
end
