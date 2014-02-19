class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :note
      t.datetime :due_date
      t.boolean :completed
      t.datetime :completed_date

      t.timestamps
    end
  end
end
