Rails.application.routes.draw do
  concern :likable do
    resource :like, only: :update
  end

  concern :commentable do
    resources :comments, only: %i[create update destroy]
  end

  resources :posts, concerns: %i[ likable commentable ]

  devise_for :users

  root to: redirect('/posts')

end
