module CommentsHelper
  def form_partial_locals(commentable)
    comment = commentable.comments.find_by(user: current_user)
    {
      commentable: commentable,
      comment: comment || commentable.comments.new
    }
  end
end
