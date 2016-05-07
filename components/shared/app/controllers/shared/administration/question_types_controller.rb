module Shared
  class Administration::QuestionTypesController < AdministrationController
    authorize_resource class: Shared::QuestionType

    def index
      @question_types = Shared::QuestionType.order :mode, :name
      @question_type  ||= Shared::QuestionType.new
    end

    def create
      @question_type = Shared::QuestionType.new(question_type_params)

      if @question_type.save
        form_message :notice, t('question_type.create.success')

        redirect_to shared.administration_question_types_path
      else
        form_error_messages_for @question_type, flash: flash.now

        render :new
      end
    end

    def update
      @question_type = Shared::QuestionType.find params[:id]

      if @question_type.update_attributes question_type_params
        form_message :notice, t('question_type.update.success')
      else
        form_error_messages_for @question_type
      end

      redirect_to shared.administration_question_types_path
    end

    def destroy
      @question_type = Shared::QuestionType.find params[:id]

      if @question_type.destroy
        form_message :notice, t('question_type.delete.success')
      else
        form_error_message t('question_type.delete.failure')
      end

      redirect_to shared.administration_question_types_path
    end

    private

    def question_type_params
      params.require(:question_type).permit(:mode, :name, :description, :icon)
    end
  end
end
