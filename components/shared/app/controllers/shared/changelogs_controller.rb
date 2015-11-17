module Shared
class ChangelogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @changelogs = Shared::Changelog.all.sort
  end
end
end
