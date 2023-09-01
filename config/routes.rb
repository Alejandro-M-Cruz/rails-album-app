Rails.application.routes.draw do

  concern :likable do
    resource :like, only: :update
  end

  resources :posts, concerns: :likable

  devise_for :users

  root to: redirect('/posts')

end
