class CategoriesController < ApplicationController
  include Watchables::Watch

  default_tab :all, only: :index

  before_action :authenticate_user!

  def index
    @categories = Category.order(:name)
    @tags       = Tag.order(:name)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to administration_dashboard_index_path(tab: 'category')
      flash[:notice] = t('category.create.success')
    else
      redirect_to administration_dashboard_index_path(tab: 'category')
    end
  end

  def category_params
    params.require(:category).permit(:name, :tags)
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      redirect_to administration_dashboard_index_path(tab: params[:tab])
    else
      redirect_to administration_dashboard_index_path(tab: params[:tab])
    end
  end
end
