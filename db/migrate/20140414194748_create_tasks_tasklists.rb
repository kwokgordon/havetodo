class CreateTasksTasklists < ActiveRecord::Migration
  def change
    create_table :tasklists_tasks, :id => false do |t|
      t.integer :task_id, :null => false
      t.integer :tasklist_id, :null => false
    end

    add_index :tasklists_tasks, [:task_id, :tasklist_id], :unique => true
  end
end
