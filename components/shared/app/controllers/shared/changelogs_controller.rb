module University
class ChangelogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @changelogs = University::Changelog.all.sort
  end
end
end
