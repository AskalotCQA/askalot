module Shared
class NewsController < Shared::ApplicationController
  before_action :authenticate_user!

  def index
    @news = Shared::New.order('news.id DESC')
  end
end
end
