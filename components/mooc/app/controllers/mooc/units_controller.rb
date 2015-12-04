module Mooc
  class UnitsController < Shared::ApplicationController
    include Shared::Events::Dispatch
    include Shared::Markdown::Process

    include Shared::MarkdownHelper

    before_action :authenticate_user!

    layout 'mooc/unit'

    def show
      @unit = Shared::Category.find params[:id]
      @questions = @unit.questions.order(created_at: :desc).page(params[:page]).per(20)
    end
  end
end
