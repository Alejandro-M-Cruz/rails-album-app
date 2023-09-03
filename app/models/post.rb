class Post < ApplicationRecord
  has_one_attached :image
  has_many :likes, dependent: :destroy, as: :likable
  has_many :comments, dependent: :destroy, as: :commentable do
    def persisted
      filter { |comment| comment.persisted? }
    end
  end
  belongs_to :user
  validates :image, presence: true
  validates :description, length: { maximum: 2000 }
  validates :public, inclusion: { in: [true, false], message: 'must be true or false' }

  SORT_METHODS = {
    'Newest first' => { created_at: :desc },
    'Oldest first' => { created_at: :asc },
    'Most recently updated' => { updated_at: :desc },
    'Least recently updated' => { updated_at: :asc },
    'Most liked' => { likes_count: :desc },
    'Least liked' => { likes_count: :asc }
  }

  TABS = {
    all_posts: 'All posts',
    my_posts: 'My posts',
    liked_posts: 'Liked posts'
  }

  def liked_by?(user)
    likes.exists?(user: user)
  end
end