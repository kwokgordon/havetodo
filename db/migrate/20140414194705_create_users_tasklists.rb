class CreateUsersTasklists < ActiveRecord::Migration
  def change
    create_table :tasklists_users, :id => false do |t|
      t.integer :user_id, :null => false
      t.integer :tasklist_id, :null => false
    end

    add_index :tasklists_users, [:user_id, :tasklist_id], :unique => true
  end
end
