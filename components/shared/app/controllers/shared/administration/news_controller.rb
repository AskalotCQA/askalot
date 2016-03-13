module Shared
  class Administration::NewsController < AdministrationController
    authorize_resource class: Shared::New

    def index
      @news = Shared::New.order('news.id DESC')
      @new ||= Shared::New.new
    end

    def create
      @new = Shared::New.new(new_params)

      if @new.save
        form_message :notice, t('news.create.success')

        redirect_to shared.administration_news_index_path
      else
        index

        render :index
      end
    end

    def update
      @new = Shared::New.find(params[:id])

      if @new.update_attributes(new_params)
        form_message :notice, t('news.update.success')

        redirect_to shared.administration_news_index_path
      else
        index

        render :index
      end
    end

    def destroy
      @new = Shared::New.find(params[:id])

      if @new.destroy
        form_message :notice, t('new.delete.success')
      else
        form_error_message t('new.delete.failure')
      end

      redirect_to shared.administration_news_index_path
    end

    private

    def new_params
      params.require(:new).permit(:title, :description, :show)
    end
  end
end
