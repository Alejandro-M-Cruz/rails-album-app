Rails.application.routes.draw do
  resources :posts
  get 'my_posts', to: 'posts#my_posts'
  get 'liked_posts', to: 'posts#liked_posts'
  patch ':likable_type/:likable_id/like', to: 'likes#update', as: :like
  devise_for :users
  root to: redirect('/posts')
end
