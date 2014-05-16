class ChangelogsController < ApplicationController
  def index
    @changelogs = Changelog.all.sort
  end
end
