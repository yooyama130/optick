class Task < ApplicationRecord
  belongs_to :user
  has_many :working_tasks, dependent: :destroy
  attachment :icon_image

  # uniqueness: { scope: :user } = 一人のユーザーがタスクの名前に同じものを使えない
  validates :content, presence: true, uniqueness: { scope: :user }
end
