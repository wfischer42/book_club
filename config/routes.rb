Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :books, only: [:index, :show, :new, :create] do
    resources :reviews, only: [:new, :create]
  end

  resources :users, only: [:show] do
    resources :reviews, only: [:destroy]
  end

  resources :authors, only: [:show]
end
