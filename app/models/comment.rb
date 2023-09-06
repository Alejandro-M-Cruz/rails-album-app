class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  validates :body, presence: true
  validate :user_commented?, on: :create

  private
    def user_commented?
      errors.add(:user, 'has already commented this post') if commentable.comments.exists?(user: user)
    end
end
