class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :note
      t.date :due_date
      t.time :due_time
      t.boolean :completed, :null => false, :default => false
      t.datetime :completed_date
      t.integer :completed_user_id

      t.timestamps
    end
  end
end
