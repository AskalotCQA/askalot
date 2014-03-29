class ChangelogsController < ApplicationController
  def index
    @changelogs = Changelog.order(version: :desc)
  end
end
