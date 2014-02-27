class ChangelogsController < ApplicationController
  def index
    @changelogs = Changelog.order(created_at: :asc)
  end
end
