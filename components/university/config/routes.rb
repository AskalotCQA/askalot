University::Engine.routes.draw do
  resources :groups, only: [:index, :new, :create, :show, :update, :destroy] do
    resources :documents, only: [:create]
  end
end
