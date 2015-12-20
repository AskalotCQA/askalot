module Shared
class Administration::DashboardController < AdministrationController
  default_tab :categories, only: :index

  def index
    render_dashboard
  end

  private

  def render_dashboard
    authorize! :administrate, nil

    @assignments = Shared::Assignment.includes(:user, :category, :role).order('categories.name', 'users.nick')
    @assignments.each { |a| a.category.name = a.category.parent.name + ' - ' + a.category.name unless a.category.root? }
    @categories  = Shared::Category.categories_with_parent_name :root
    @changelogs  = Shared::Changelog.all.sort

    @assignment ||= Shared::Assignment.new
    @category   ||= Shared::Category.new
    @changelog  ||= Shared::Changelog.new
    @email      ||= Shared::Email.new

    render 'shared/administration/dashboard/index'
  end
end
end
