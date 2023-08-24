class Post < ApplicationRecord
  has_one_attached :image
  has_many :likes, dependent: :destroy, as: :likable
  belongs_to :user
  validates :image, presence: true
  validates :description, length: { maximum: 200 }
  validates :public, inclusion: { in: [true, false], message: 'must be true or false' }

  def liked_by?(user)
    likes.exists?(user: user)
  end

end