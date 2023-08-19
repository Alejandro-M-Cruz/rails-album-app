class Posts::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def update
    if @post.liked_by? current_user
      @post.likes.where(user: current_user).destroy_all
    else
      @post.likes.create user: current_user
    end
  end

  private

    def set_post
      @post = Post.find(params[:post_id])
    end
end