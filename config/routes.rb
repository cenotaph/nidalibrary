Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: { sessions: 'api/v1/sessions',  token_validations: 'api/v1/token_validations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: 'api' do
    namespace :v1 do
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
    end
  end
end
