module Shared
class NewsController < Shared::ApplicationController
  before_action :authenticate_user!

  def index
    @all_news = Shared::News.order('news.id DESC')
  end
end
end
