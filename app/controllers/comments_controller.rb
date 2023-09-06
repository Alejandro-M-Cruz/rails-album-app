class CommentsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!, only: %i[ create update destroy ]
  before_action :set_comment, only: %i[ update destroy ]
  before_action :check_comment_owner, only: %i[ update destroy ]
  before_action :set_commentable, only: %i[ create update destroy ]
  before_action :check_commentable_visibility, only: %i[ update destroy ]
  after_action :refresh_comments_section, only: %i[ destroy ]

  # POST /comments or /comments.json
  def create
    @comment = @commentable.comments.new(**comment_params, user: current_user)
    @comment.save
    flash.notice = 'Comment successfully created'
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    @comment.update(comment_params)
    flash.notice = 'Comment successfully updated'
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy
    flash.notice = 'Comment successfully deleted'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def commentable_from_id_param
      params.each_pair do |param_name, param_value|
        if param_name =~ /(.+)_id$/
          return $1&.classify&.constantize&.find(param_value)
        end
      end
    end

    def set_commentable
      @commentable = @comment ? @comment.commentable : commentable_from_id_param
    end

    def user_not_allowed
      redirect_to root_path, alert: 'You are not allowed to perform this action'
    end

    def check_comment_owner
      user_not_allowed unless @comment.user.eql?(current_user)
    end

    def check_commentable_visibility
      user_not_allowed unless @commentable.public? || @commentable.user.eql?(current_user)
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:commentable_id, :body)
    end

    def refresh_comments_section
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@commentable, :comments),
            partial: 'comments/comments',
            locals: { commentable: @commentable }
          )
        end
      end
    end
end
