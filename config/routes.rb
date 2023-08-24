Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  get 'drinks/suggestion', to: 'drinks#suggestion', as: 'drinks_suggestion'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  get 'logout', to: 'user_sessions#destroy', as: 'logout'
  get 'profile/:id', to: 'profiles#show', as: 'profile'
  get 'profile/:id/edit', to: 'profiles#edit', as: 'edit_profile'
  patch 'profile/:id', to: 'profiles#update'
  get 'mypage/calendar'
  post '/callback', to: 'line_bot_messages#callback'
  get 'line_login/login', to: 'line_login#login'
  get 'line_login/callback', to: 'line_login#callback'
  get 'line_login/add_friend', to: 'line_login#add_friend'
  get 'users/link_line_account', to: 'users#link_line_account', as: :link_line_account

  resources :users, only: %i[new create]
  resources :profile, only: %i[show edit update]
  resources :drinks do
    collection do
      post :suggestion
    end
  end
  resources :drink_records, only: %i[create show edit update destroy]
  resources :password_resets, only: %i[new create edit update]
  # Defines the root path route ("/")
  root 'tops#index'
end
