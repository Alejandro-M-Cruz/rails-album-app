module PostsHelper
  def post_belongs_to_current_user?
    @post.user.eql? current_user
  end
end
