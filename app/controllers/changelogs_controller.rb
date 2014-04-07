class ChangelogsController < ApplicationController
  def index
    @changelogs = Changelog.order(version: :desc)
  end

  def new
    @changelog = Changelog.new
  end

  def create
    @changelog = Changelog.new(changelog_params)
    if @changelog.save
    else
      render 'new'
    end
  end

  def changelog_params
    params.require(:changelog).permit(:title, :text)
  end

end
