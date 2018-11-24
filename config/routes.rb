Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'books#index'

  # resources :books, only: [:new, :index, :destroy, :show, :create] do
  #   resources :reviews, only: [:new, :create]
  # end

  get '/books/new', to: 'books#new', as: "new_book"
  get '/books', to: 'books#index'
  delete '/books/:id', to: 'books#destroy'
  get '/books/:id', to: 'books#show', as: "book"
  post '/books', to: 'books#create'

  get '/books/:book_id/reviews/new', to: 'reviews#new', as: "new_book_review"
  post '/books/:book_id/reviews', to: 'reviews#create', as: 'book_reviews'

  # resources :users, only: [:show] do
  #   resources :reviews, only: [:destroy]
  # end

  delete '/users/:user_id/reviews/:id', to: "reviews#destroy", as: "user_review"
  get '/users/:id', to: "users#show", as: 'user'

  get '/authors/:id', to: "authors#show", as: "author"
  delete '/authors/:id', to: "authors#destroy"

  # resources :authors, only: [:show, :destroy]
end
