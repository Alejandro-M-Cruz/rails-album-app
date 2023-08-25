class LikesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_likable

  def update
    @likable.liked_by?(current_user) ? destroy_like : like
    replace_likes_partial
  end

  private
    def set_likable
      @likable = params[:likable_type].constantize.find(params[:likable_id])
    end

    def like
      @likable.likes.create(user: current_user)
    end

    def destroy_like
      @likable.likes.where(user: current_user).destroy_all
    end

    def replace_likes_partial
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@likable, :likes),
            partial: 'likes/likes',
            locals: { likable: @likable }
          )
        end
      end
    end
end