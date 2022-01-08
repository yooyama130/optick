class Task < ApplicationRecord
  belongs_to :user
  has_many :working_tasks
end
