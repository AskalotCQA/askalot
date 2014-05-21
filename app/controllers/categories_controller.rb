class CategoriesController < ApplicationController
  include Watchables::Watch

  default_tab :all, only: :index

  before_action :authenticate_user!

  def index
    @categories = Category.order(:name)
    @tags       = Tag.order(:name)
  end

  def create
    authorize! :administrate, nil

    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = t('category.create.success')
    else
      form_error_messages_for @category
    end

    redirect_to administration_dashboard_index_path(tab: 'category')
  end

  def update
    authorize! :administrate, nil

    @category = Category.find(params[:id])

    if @category.update_attributes(category_params)
      flash[:notice] = t('category.update.success')
    else
      form_error_messages_for @category
    end

    redirect_to administration_dashboard_index_path(tab: 'category')
  end

  private

  def category_params
    params.require(:category).permit(:name, :tags)
  end
end
