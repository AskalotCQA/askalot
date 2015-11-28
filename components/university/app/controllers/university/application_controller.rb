module University
  class ApplicationController < Shared::ApplicationController
    ApplicationController.append_view_path('components/university/app/views')
  end
end
