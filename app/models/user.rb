class User < ApplicationRecord
  has_many :posts
  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :picture_size

  private

  def picture_size
    erros.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
  end
end
