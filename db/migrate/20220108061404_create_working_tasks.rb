class CreateWorkingTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :working_tasks do |t|
      t.integer :user_id
      t.integer :task_id
      t.datetime :started_at
      t.datetime :stopped_at
      t.integer :working_time
      t.boolean :being_measured?, default: true

      t.timestamps
    end
  end
end
