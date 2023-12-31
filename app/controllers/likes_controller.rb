class LikesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_likable

  def update
    @likable.liked_by?(current_user) ? destroy_like : like
    refresh_likes_view
  end

  private
    def set_likable
      params.each_pair do |param_name, param_value|
        @likable = $1&.classify&.constantize&.find(param_value) if param_name =~ /(.+)_id$/
      end
    end

    def like
      @likable.likes.create(user: current_user)
    end

    def destroy_like
      @likable.likes.where(user: current_user).destroy_all
    end

    def refresh_likes_view
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