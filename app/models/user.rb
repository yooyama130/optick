class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :tasks, dependent: :destroy
  has_many :working_tasks, dependent: :destroy
  has_many :events, dependent: :destroy
  attachment :profile_image

  validates :name, presence: true, length: { maximum: 15 }
end
