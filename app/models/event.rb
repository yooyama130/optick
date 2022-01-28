class Event < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 20 }
  validates :start_date, presence: true
  validates :end_date, presence: true
end
