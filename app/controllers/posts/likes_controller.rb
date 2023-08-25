class Posts::LikesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_post

  def update
    @post.liked_by?(current_user) ? destroy_post_like : like_post
    replace_likes_partial
  end

  private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def like_post
      @post.likes.create(user: current_user)
    end

    def destroy_post_like
      @post.likes.where(user: current_user).destroy_all
    end

    def replace_likes_partial
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@post, :likes),
            partial: 'posts/likes',
            locals: { post: @post }
          )
        end
      end
    end
end