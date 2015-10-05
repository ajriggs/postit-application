PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/authenticate', to: 'sessions#authenticate'
  post '/authenticate', to: 'sessions#authenticate'

  resources :posts, except: :destroy do
    member do
      post 'vote'
    end
    resources :comments, only: :create do
      member do
        post 'vote'
      end
    end
  end
  resources :categories, only: [:new, :create, :show]
  resources :users, only: [:show, :edit, :update]

end
