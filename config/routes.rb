require 'sidekiq/web'

Rails.application.routes.draw do
  #authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  #end

  use_doorkeeper
  devise_for :users, skip: [:registrations], controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection        
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    post '/users/confirm_email' => 'users#confirm_email', as: :confirm_email  
    get '/users/signup' => 'devise/registrations#new', as: :new_user_registration
    post '/users/signup' => 'devise/registrations#create', as: :user_registration 
  end
  concern :votable do
    post :vote_up, on: :member
    post :vote_down, on: :member    
    post :vote_cancel, on: :member    
  end

  resources :questions, concerns: [:votable] do
    resources :comments, shallow: true, only: [:create, :update, :destroy], defaults: { commentable_type: 'question' }
    resources :answers, shallow: true, concerns: [:votable] do
      resources :comments, shallow: true, only: [:create, :update, :destroy], defaults: { commentable_type: 'answer' }
      patch :best, on: :member
    end
    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  resources :attachments, only: :destroy
  get 'search', to: 'search#index'  
  root to: "questions#index"
end
