class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :user_id
      t.datetime :start_time
      t.integer :task_amout
      t.string :event_name

      t.timestamps
    end
  end
end
