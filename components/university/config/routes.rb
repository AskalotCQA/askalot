University::Engine.routes.draw do
  resources :groups, only: [:index, :new, :create, :show, :update, :destroy] do
    resources :documents, only: [:create]
  end

  resources :documents, [:update, :destroy] do
    resources :questions, [] do
      get :document_index, on: :collection, as: :index
    end
  end
end
