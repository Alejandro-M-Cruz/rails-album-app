require "test_helper"

class PostTest < ActiveSupport::TestCase
  test 'public is initially false' do
    assert_equal false, Post.new.public
  end

  test 'error if public is nil' do
    post = Post.new(public: nil)
    post.validate
    assert_not_empty post.errors[:public]
  end

  test 'error if user is nil' do
    post = Post.new(user: nil)
    post.validate
    assert_not_empty post.errors[:user]
  end

  test 'error if no image is attached' do
    post = Post.new
    post.validate
    assert_not_empty post.errors[:image]
  end

  test 'error if description is too long' do
    post = Post.new(description: generate_string(201))
    post.validate
    assert_equal 201, post.description.length
    assert_not_empty post.errors.where(:description, :too_long)
  end

  test 'no error if description is 200 characters long' do
    post = Post.new(description: generate_string(200))
    post.validate
    assert_equal 200, post.description.length
    assert_empty post.errors.where(:description)
  end

  test 'liked_by? returns false if user has not liked the post' do
    user = users(:one)
    post = posts(:post_with_no_likes)
    assert_not post.liked_by?(user)
  end

  test 'liked_by? returns true if user has liked post' do
    user = users(:one)
    post = posts(:post_with_no_likes)
    post.likes.create(user: user)
    assert post.liked_by?(user)
  end

  private
    def generate_string(length)
      (1..length).to_a.map { 'a' }.join('')
    end
end
