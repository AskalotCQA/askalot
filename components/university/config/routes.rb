University::Engine.routes.draw do
  resources :groups, only: [:index, :new, :create, :show, :update, :destroy] do
    resources :documents, only: [:create]
  end

  resources :documents, only: [:update, :destroy] do
    resources :questions do
      get :document_index, on: :collection, as: :index
    end
  end

  get '/third_party/:hash/:name',     to: 'third_party#index', as: 'third_party_index'
  get '/third_party/:hash/:name/:id', to: 'third_party#show',  as: 'third_party_question'
end
