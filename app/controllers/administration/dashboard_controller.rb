class Administration::DashboardController < AdministrationController
  default_tab :categories, only: :index

  def index
    render_dashboard
  end

  private

  def render_dashboard
    authorize! :administrate, nil

    @assignments = Assignment.includes(:user, :category, :role).order('categories.name', 'users.nick')
    @categories  = Category.order(:name)
    @changelogs  = Changelog.all.sort

    @assignment ||= Assignment.new
    @category   ||= Category.new
    @changelog  ||= Changelog.new

    render 'administration/dashboard/index'
  end
end
