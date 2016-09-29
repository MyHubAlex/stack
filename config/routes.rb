Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :votable do
    post :vote_up, on: :member
    post :vote_down, on: :member    
    post :vote_cancel, on: :member    
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  
  root to: "questions#index"
end
