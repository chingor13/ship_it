ShipIt::Application.routes.draw do

  resources :projects do
    resources :environments, only: [:show] do
      resources :deployments, only: [:create, :show] do
        member do
          get :log
          get :terminate
        end
      end
      member do
        get :changes
      end
    end

    resources :deploy_options, only: [:new, :create, :destroy]
  end

  resources :deployments, only: [] do
    get :in_progress, on: :collection
  end

  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/login', :to => redirect('/auth/avvo'), :as => 'login'
  get '/logout', :to => 'sessions#destroy', :as => 'logout'

  root to: "sessions#homepage"
end
