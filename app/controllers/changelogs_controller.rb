class ChangelogsController < ApplicationController
  def index
    @changelogs = Changelog.order(:version)
  end
end
