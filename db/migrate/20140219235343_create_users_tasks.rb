class CreateUsersTasks < ActiveRecord::Migration
  def change
    create_table :users_tasks, :id => false do |t|
      t.integer :user_id, :null => false
      t.integer :task_id, :null => false
    end
    
    add_index :users_tasks, [:user_id, :task_id], :unique => true
  end
end
