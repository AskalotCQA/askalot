module University
class ChangelogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @changelogs = Changelog.all.sort
  end
end
end
