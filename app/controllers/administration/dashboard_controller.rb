class Administration::DashboardController < AdministrationController
  default_tab :categories, only: :index

  def index
    render_dashboard
  end

  private

  def render_dashboard
    authorize! :administrate, nil

    @categories = Category.order(:name)
    @changelogs = Changelog.all.sort

    @category  ||= Category.new
    @changelog ||= Changelog.new

    @assignment ||= Assignment.new

    render 'administration/dashboard/index'
  end
end
