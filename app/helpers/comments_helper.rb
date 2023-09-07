module CommentsHelper
  def comment_form_partial_locals(commentable, user)
    comment = commentable.comments.find_by(user: user)
    {
      commentable: commentable,
      comment: comment || commentable.comments.new
    }
  end
end
