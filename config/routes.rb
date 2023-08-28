Rails.application.routes.draw do

  concern :likable do
    resource :like, only: :update
  end

  resources :posts, concerns: :likable
  get 'my_posts', to: 'posts#my_posts'
  get 'liked_posts', to: 'posts#liked_posts'

  devise_for :users

  root to: redirect('/posts')

end
