class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  validates :body, length: { in: 1..1000 }
  validate :user_commented?, on: :create

  SORT_METHODS = {
    'Newest first' => { created_at: :desc },
    'Oldest first' => { created_at: :asc },
    'Most recently updated' => { updated_at: :desc },
    'Least recently updated' => { updated_at: :asc },
  }

  private
    def user_commented?
      errors.add(:user, 'has already commented this post') if commentable.comments.exists?(user: user)
    end
end
