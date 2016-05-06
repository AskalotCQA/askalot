module Shared
  class Administration::NewsController < AdministrationController
    authorize_resource class: Shared::News

    def index
      @all_news = Shared::News.order('news.id DESC')
      @news ||= Shared::News.new
    end

    def create
      @news = Shared::News.new(news_params)

      if @news.save
        form_message :notice, t('news.create.success')

        redirect_to shared.administration_news_index_path
      else
        index

        render :index
      end
    end

    def update
      @news = Shared::News.find(params[:id])

      if @news.update_attributes(news_params)
        form_message :notice, t('news.update.success')

        redirect_to shared.administration_news_index_path
      else
        index

        render :index
      end
    end

    def destroy
      @news = Shared::News.find(params[:id])

      if @news.destroy
        form_message :notice, t('news.delete.success')
      else
        form_error_message t('news.delete.failure')
      end

      redirect_to shared.administration_news_index_path
    end

    private

    def news_params
      params.require(:news).permit(:title, :description, :show)
    end
  end
end
