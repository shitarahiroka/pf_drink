Rails.application.routes.draw do
  get 'drinks/suggestion', to: 'drinks#suggestion', as: 'drinks_suggestion'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  get 'logout', to: 'user_sessions#destroy', as: 'logout'
  get 'profile/:id', to: 'profiles#show', as: 'profile'
  get 'profile/:id/edit', to: 'profiles#edit', as: 'edit_profile'
  patch 'profile/:id', to: 'profiles#update'
  get 'mypage/calendar'

  resources :users, only: %i[new create]
  resources :profile, only: %i[show edit update]
  resources :drinks do
    collection do
      post :suggestion
    end
  end
  resources :drink_records, only: %i[create show]
  # Defines the root path route ("/")
  root "tops#index"
end
