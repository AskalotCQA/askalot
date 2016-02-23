module University::Application
  extend ActiveSupport::Concern

  included do
    layout 'university/application'
    prepend_view_path 'components/university/app/views'
  end
end
