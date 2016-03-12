module Shared
class NewsController < ApplicationController
  before_action :authenticate_user!

  def index
    @news = Shared::New.order('news.created_at DESC')
  end
end
end
