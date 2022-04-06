Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: { sessions: 'api/v1/sessions',  token_validations: 'api/v1/token_validations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: 'api' do
    namespace :v1 do
      resources :books do
        collection do
          get :search_oclc
        end
        member do
          get :missing
          get :found
        end
      end

      resources :collections do
        resources :books
      end
      
      resources :deweys do

      end
      resources :statuses do
        resources :books
      end
      resources :fasts do
        resources :books
      end
      resources :sections do
        resources :books

        member do 
          get :shelfread
        end
      end
      get '/housekeeping/all_books', to: 'deweys#all_books'
      post '/deweys/books', to: 'deweys#books'
      get '/housekeeping/dewey_sweep', to: 'housekeeping#dewey_sweep'
      get '/housekeeping/dewey_entries', to: 'housekeeping#dewey_entries'
       get '/housekeeping/old_order', to: 'housekeeping#old_order'
      get '/housekeeping/:id/clean_commas', to: 'housekeeping#clean_commas'
      get '/housekeeping/probably_healthy_authors', to: 'housekeeping#probably_healthy_authors'
      get '/housekeeping/problem_authors', to: 'housekeeping#problem_authors'
      get '/housekeeping/unclassified', to: 'housekeeping#unclassified'
      get '/housekeeping/mapcallnos', to: 'housekeeping#mapcallnos'
      get '/housekeeping/check_callnos', to: 'housekeeping#check_callnos'
      get '/search', to: 'search#search'
      post '/search', to: 'search#search'
      post '/classify' , to: 'search#classify'
    end
  end
end
