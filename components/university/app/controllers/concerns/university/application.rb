module University::Application
  extend ActiveSupport::Concern

  included do
    layout 'university/application'
    prepend_view_path 'components/university/app/views'

    def determine_context
      @context = Shared::Tag.current_academic_year_value

      Shared::ApplicationHelper.current_context=(@context)
    end
  end
end
