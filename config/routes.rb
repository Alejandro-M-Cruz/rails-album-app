Rails.application.routes.draw do
  resources :posts
  get 'my_posts', to: 'posts#my_posts'
  devise_for :users
  root to: redirect('/posts')
end
