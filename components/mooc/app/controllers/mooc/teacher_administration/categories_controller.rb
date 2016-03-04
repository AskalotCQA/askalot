module Mooc
  class TeacherAdministration::CategoriesController < TeacherAdministrationController
    def index
      authorize! :teacher_administrate, :index

      @categories = Shared::Category.in_contexts(contexts_to_administrate).includes(:assignments).order(:lft)
    end

    def edit
      # TODO (ladislav.gallay) Authorisation based on category
      authorize! :teacher_administrate, :edit

      @category = Shared::Category.find params[:id]
    end

    def update
      # TODO (ladislav.gallay) Authorisation based on category
      authorize! :teacher_administrate, :update

      @category = Shared::Category.find(params[:id])

      if @category.update_attributes(category_params)
        form_message :notice, t('category.update.success')
      else
        form_error_messages_for @category
      end

      redirect_to mooc.teacher_administration_root_path
    end

    def update_settings
      authorize! :teacher_administrate, :update_settings

      Shared::Category.in_contexts(contexts_to_administrate).update_all askable: false
      Shared::Category.in_contexts(contexts_to_administrate).update_all shared: false
      Shared::Category.in_contexts(contexts_to_administrate).where(id: params[:askable]).update_all askable: true
      Shared::Category.in_contexts(contexts_to_administrate).where(id: params[:shared]).update_all shared: true

      render json: { success: true }
    end

    private

    def contexts_to_administrate
      return [] if contexts.empty?

      contexts.map(&:name).include?(@context) ? [@context] : []
    end

    def category_params
      params.require(:category).permit(:name, :tags, :shared, :askable, :teacher_assistant_ids => [])
    end
  end
end
