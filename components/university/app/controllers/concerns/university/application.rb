module University::Application
  extend ActiveSupport::Concern

  included do
    layout 'university/application'
    prepend_view_path 'components/university/app/views'

    def determine_context
      @context = Tag.current_academic_year_value
    end
  end
end
