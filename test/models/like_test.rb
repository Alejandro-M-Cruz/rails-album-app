require "test_helper"

class LikeTest < ActiveSupport::TestCase
  setup do
    @like = likes(:valid_like)
  end

  test 'error when user is nil' do
    @like.user = nil
    assert_not @like.valid?
    assert_equal ["must exist"], @like.errors[:user]
  end

  test 'error when likable is nil' do
    @like.likable = nil
    assert_not @like.valid?
    assert_equal ["must exist"], @like.errors[:likable]
  end
end
