class Article < ApplicationRecord
  belongs_to :user
  has_many :likes
  has_many :liked_users,through: :likes,source: :user
  has_many :comments,dependent: :destroy
  validates :title,:video,:presence => true,length: {minimum: 5}
  mount_uploader :video, VideoUploader
end
