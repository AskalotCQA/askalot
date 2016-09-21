module Mooc
  class TeacherAdministration::CategoriesController < TeacherAdministrationController
    before_action :authorize_action
    before_action :check_parent, only: [:new, :create]

    def index
      @categories = Shared::Category.in_contexts(contexts_to_administrate).unscoped.includes(:assignments).order(:lft)
    end

    def new
      @category         = Shared::Category.new params.permit([:parent_id, :uuid])
      @parent           = Shared::Category.find(params[:parent_id]) if params[:parent_id]
      @category.askable = true
    end

    def create
      @category = Shared::Category.new(category_params)
      parent_id = params[:parent_id] || params[:category][:parent_id]

      if parent_id
        @parent             = Shared::Category.find parent_id
        @category.parent_id = parent_id
      end

      if @category.save
        form_message :notice, t('category.create.success')

        redirect_to mooc.teacher_administration_categories_path
      else
        form_error_messages_for @category, flash: flash.now

        render :new
      end
    end

    def edit
      @category = Shared::Category.find params[:id]
    end

    def update
      @category = Shared::Category.find(params[:id])

      if @category.update_attributes(category_params)
        form_message :notice, t('category.update.success')
      else
        form_error_messages_for @category
      end

      redirect_to mooc.teacher_administration_root_path
    end

    def update_settings
      Shared::Category.in_contexts(contexts_to_administrate).all.each do |category|
        askable =  params[:askable] ? params[:askable].include?(category.id.to_s) : false

        if category.askable != askable
          category.askable = askable

          category.save
        end
      end

      render json: { success: true }
    end

    private

    def contexts_to_administrate
      return [] if contexts.empty?

      contexts.map(&:id).include?(@context_id) ? [@context_id] : []
    end

    def category_params
      params.require(:category).permit(:name, :tags, :askable, :teacher_assistant_ids => [])
    end

    def check_parent
      raise 'Access not allowed.' unless check_category_permissions(params[:parent_id] || params[:category][:parent_id])
    end

    def check_category_permissions(category_id)
      return false if contexts.empty? || category_id.empty?

      Shared::Category.in_contexts(contexts_to_administrate).map(&:id).include? category_id.to_i
    end

    def authorize_action
      authorize! :teacher_administrate, :all
    end
  end
end
