Rails.application.routes.draw do
  devise_for :users, skip: [:registrations, :sessions], :controllers => { :sessions => "sessions", :registrations => "registrations" }
  
  devise_scope :user do
    get 'users/sign_in' => 'sessions#new', to: redirect('/')
    post 'users/sign_in' => 'sessions#create' # , :as => :new_user_session
    delete 'users/sign_out' => 'sessions#destroy' # , :as => :destroy_user_session
    
    resource :registration,
      only: [:create, :edit, :update],
      path: 'users',
      as: :user_registration
  end
  
  get '/users/password/edit', to: 'passwords#edit'
  get '/users/password/get_question_num', to: 'passwords#get_question_num'
  patch '/users/password', to: 'passwords#update'
  
  namespace :admin do
    root "base#index"
    
    resources :users
    
    get '/urls/a_urls_list', to: 'urls#a_urls_list'
    get '/urls/urls_list', to: 'urls#urls_list'
    delete '/urls/destroy_a_url/:id', to: 'urls#destroy_a_url'
    delete '/urls/destroy_url/:id', to: 'urls#destroy_url'
    
    get '/messages', to: 'messages#index'
    get '/messages/:id', to: 'messages#show'
    delete '/messages/:id', to: 'messages#destroy'
  end
  
  get '/dashboard', to: 'user_url#index'
  post '/dashboard', to: 'user_url#create'
  delete '/dashboard/:id', to: 'user_url#destroy'
  get '/dashboard/:id', to: 'user_url#edit'
  patch '/dashboard/:id', to: 'user_url#update'
  
  get '/:id', to: 'user_url#go'
  get '/password/:id', to: 'user_url#password'
  get '/p_go/:id', to: 'user_url#password_go'
  
  post '/a', to: 'anonymous_url#create'
  get  '/a/:id', to: 'anonymous_url#go'
  
  post '/message', to: 'messages#create'
  
  get '/pages/index'
  get '/pages/privacy_policy'
  get '/pages/terms_of_service'
  get '/pages/sitemap'
  
  root 'pages#index'
  
  match '/404', to: 'errors#page_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
