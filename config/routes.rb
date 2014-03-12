Askalot::Application.routes.draw do
  root 'static_pages#home'

  get '/404', to: 'errors#show'
  get '/500', to: 'errors#show'

  devise_for :users, controllers: { sessions: :sessions, registrations: :registrations }, path: '', path_names: { sign_up: :join, sign_in: :login, sign_out: :logout }

  resources :users, only: [:index] do
    patch :profile, on: :collection, to: 'users#update'
    get   :suggest, on: :collection
  end

  get 'users/:nick', to: 'users#show', as: :user

  get 'welcome', to: 'static_pages#welcome'

  concern :commetable do
    resources :comments, only: [:create, :update]

    get :comment, on: :member
  end

  concern :deletable do
    get :delete, on: :member
  end

  concern :evaluable do
    resources :evaluations, only: [:create, :update]

    get :evaluation, on: :member
  end

  concern :votable do
    get :voteup, on: :member
    get :votedown, on: :member
  end

  resources :categories, only: [:index]
  resources :changelogs, only: [:index]

  resources :questions, only: [:index, :new, :create, :show, :update] do
    resources :answers, only: [:create, :update]

    get :favor,   on: :member
    get :suggest, on: :collection

    concerns :commetable
    concerns :deletable
    concerns :evaluable
    concerns :votable
  end

  resources :answers, only: [] do
    get :label, on: :member

    concerns :commetable
    concerns :deletable
    concerns :evaluable
    concerns :votable
  end

  resources :comments, only: [] do
    concerns :deletable
  end

  resources :tags, only: [] do
    get :suggest, on: :collection
  end

  resources :markdown, only: [] do
    post :preview, on: :collection
  end

  get :statistics, to: 'statistics#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
