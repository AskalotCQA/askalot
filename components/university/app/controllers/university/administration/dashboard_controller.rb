module University
class Administration::DashboardController < AdministrationController
  default_tab :categories, only: :index

  def index
    render_dashboard
  end

  private

  def render_dashboard
    authorize! :administrate, nil

    @assignments = University::Assignment.includes(:user, :category, :role).order('categories.name', 'users.nick')
    @categories  = University::Category.order(:name)
    @changelogs  = University::Changelog.all.sort

    @assignment ||= University::Assignment.new
    @category   ||= University::Category.new
    @changelog  ||= University::Changelog.new
    @email      ||= University::Email.new

    render 'university/administration/dashboard/index'
  end
end
end
