class ChangelogsController < ApplicationController
  def index
    @changelogs = Changelog.all
  end
end