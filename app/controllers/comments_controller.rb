class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :set_commentable, only: %i[ create ]

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(**comment_params, user: current_user, commentable: @commentable)
    @comment.save!
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_commentable
      params.each_pair do |param_name, param_value|
        @commentable = $1&.classify&.constantize&.find(param_value) if param_name =~ /(.+)_id$/
      end
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:commentable_id, :body)
    end
end
