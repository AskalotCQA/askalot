module MOOC
  class ApplicationController < Shared::ApplicationController
    ApplicationController.append_view_path('components/mooc/app/views')
  end
end
