class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook twitter google_oauth2]
  has_many :articles, dependent: :destroy
  has_many :likes,dependent: :destroy
  has_many :liked_articles,through: :likes,source: :article
  validates :name, presence: true, unless: :uid? #他省略
  validates :email, presence: true, unless: :uid?
  validates :password, presence: true, unless: :uid?
  validates :profile,length: {maximum: 200}
  mount_uploader :image,ImgUploader
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :comments,dependent: :destroy
  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy

 has_many :followings, through: :following_relationships

 has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy

 has_many :followers, through: :follower_relationships
 def already_liked?(article)
    self.likes.exists?(article_id: article.id)
  end

  def following?(other_user)
    following_relationships.find_by(following_id: other_user.id)
  end

  def follow!(other_user)
    following_relationships.create!(following_id: other_user.id)
  end

  def unfollow!(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

end
