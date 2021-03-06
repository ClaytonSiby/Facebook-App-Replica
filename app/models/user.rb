class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :friend_sent, class_name: 'Friendship',
                        foreign_key: 'sent_by_id',
                        inverse_of: 'sent_by',
                        dependent: :destroy

  has_many :friend_request, class_name: 'Friendship',
                          foreign_key: 'sent_to_id',
                          inverse_of: 'sent_to',
                          dependent: :destroy

  has_many :friends, -> { merge(Friendship.friends) },
           through: :friend_sent, source: :sent_to

  has_many :pending_requests, -> { merge(Friendship.not_friends) } ,
          through: :friend_sent, source: :sent_to

  has_many :received_requests, -> { merge(Friendship.not_friends) },
          through: :friend_request, source: :sent_by

  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :picture_size

  def full_name
    "#{first_name} #{last_name}"
  end

  def friends_and_own_posts
    myfriends = friends

    our_posts = []

    myfriends.each do |friend|
      friend.posts.each do |post|
        our_posts << post
      end
    end

    posts.each do |post|
      our_posts << post
    end

    our_posts
  end

  private

  def picture_size
    erros.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
  end
end
