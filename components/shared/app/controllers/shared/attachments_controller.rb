module Shared
  class AttachmentsController < ApplicationController
    include Shared::Deletables::Destroy

    include Shared::Events::Dispatch
    include Shared::Watchings::Register

    before_action :authenticate_user!

    protected

    def destroy_callback(deletable)
      respond_to do |format|
        format.html { redirect_to :back, format: :html }
        format.js   { redirect_to question_path(@deletable.to_question), format: :js }
      end
    end
  end
end
