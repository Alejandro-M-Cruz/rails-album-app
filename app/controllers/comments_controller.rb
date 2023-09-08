class CommentsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!, only: %i[ create update destroy ]
  before_action :set_comment, only: %i[ update destroy ]
  before_action :check_comment_owner, only: %i[ update destroy ]
  before_action :set_commentable, only: %i[ create update destroy ]
  before_action :check_commentable_visibility, only: %i[ update destroy ]

  # POST /comments or /comments.json
  def create
    @comment = @commentable.comments.new(**comment_params, user: current_user)
    if @comment.save
      # redirect_to @commentable, notice: 'Comment successfully created'
      refresh_comments_section('Comment successfully created')
    else
      refresh_comment_form
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    if @comment.update(comment_params)
      # redirect_to @commentable, notice: 'Comment successfully updated'
      refresh_comments_section('Comment successfully updated')
    else
      refresh_comment_form
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    if @comment.destroy
      # redirect_to @commentable, notice: 'Comment successfully deleted'
      refresh_comments_section('Comment successfully deleted')
    else
      refresh_comment_form
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def commentable_from_id_param
      params.each_pair do |param_name, param_value|
        return $1&.classify&.constantize&.find(param_value) if param_name =~ /(.+)_id$/
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

    def refresh_comment_form
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@comment, :form),
            partial: 'comments/form',
            locals: { comment: @comment, commentable: @commentable }
          )
        end
      end
    end

    def refresh_comments_section(notice_message)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              dom_id(@commentable, :comments),
              partial: 'comments/comments',
              locals: { commentable: @commentable }
            ),
            helpers.show_flash(:notice, notice_message)
          ]
        end
      end
    end
end
