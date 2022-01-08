class CreateWorkingTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :working_tasks do |t|
      t.integer :user_id
      t.integer :task_id
      t.integer :event_id
      t.datetime :started_at
      t.datetime :ended_at
      t.boolean :goal_task?, default: false

      t.timestamps
    end
  end
end
