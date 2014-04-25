class CreateTaskComments < ActiveRecord::Migration
  def change
    create_table :task_comments do |t|
      t.integer :task_id, :null => false
      t.integer :user_id, :null => false
      t.string :user_name, :null => false
      t.text :comment

      t.timestamps
    end
  end
end
