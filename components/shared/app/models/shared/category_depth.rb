module Shared
  class CategoryDepth
    module ClassMethods
      def depths
        @depths ||= Shared::Configuration.category_depths
      end

      def public_depths
        @public_depths ||= depths.select { |item| item['is_in_public_name'] }.map { |item| item['depth'].to_i }.reject { |item| item.nil? }
      end
    end

    extend ClassMethods
  end
end
