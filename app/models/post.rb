class Post < ApplicationRecord
  has_one_attached :image
  has_many :likes, dependent: :destroy, as: :likable
  belongs_to :user
  validates :image, presence: true
  validates :description, length: { maximum: 200 }

  def liked_by?(user)
    likes.where(user: user).exists?
  end

end