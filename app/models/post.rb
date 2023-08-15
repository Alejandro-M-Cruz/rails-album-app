class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  validates :image, presence: true
  validates :description, length: { maximum: 200 }
end
