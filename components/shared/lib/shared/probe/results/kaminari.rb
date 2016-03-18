module Shared::Probe
  class Results
    module Kaminari
      extend ActiveSupport::Concern

      included do
        alias :page        :current_page
        alias :num_pages   :total_pages
        alias :limit_value :per_page
      end
    end
  end
end
