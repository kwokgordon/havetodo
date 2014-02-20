class CreateUsersTasks < ActiveRecord::Migration
  def change
    create_table :tasks_users, :id => false do |t|
      t.integer :task_id, :null => false
      t.integer :user_id, :null => false
    end
    
    add_index :tasks_users, [:user_id, :task_id], :unique => true
  end
end
