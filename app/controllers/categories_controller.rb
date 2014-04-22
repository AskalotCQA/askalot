class CategoriesController < ApplicationController
  before_action :authenticate_user!

  include Watchings::Watching
  include Editing

  def index
    @categories = Category.order(:name)
    @tags       = Tag.order(:name)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_dashboard_index_path(tab: params[:tab])
    else
      redirect_to admin_dashboard_index_path(tab: params[:tab])
    end
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      redirect_to admin_dashboard_index_path(tab: params[:tab])
    else
      redirect_to admin_dashboard_index_path(tab: params[:tab])
    end
  end

end
