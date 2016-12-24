Rails.application.routes.draw do
  devise_for :users
  resources :books do
    member do
      get :missing
      get :found
    end
  end
  resources :statuses do
    resources :books
  end
  resources :sections do
    resources :books
    member do 
      get :shelfread
    end
  end
  get '/search', to: 'search#search'
  post '/search', to: 'search#search'
  root to: 'books#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
