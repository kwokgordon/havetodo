class CreateTaskComments < ActiveRecord::Migration
  def change
    create_table :task_comments do |t|
      t.integer :task_id
      t.integer :user_id
      t.string :user_name
      t.text :comment

      t.timestamps
    end
  end
end
