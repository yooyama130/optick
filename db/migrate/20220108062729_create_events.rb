class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.string :name

      t.timestamps
    end
  end
end
