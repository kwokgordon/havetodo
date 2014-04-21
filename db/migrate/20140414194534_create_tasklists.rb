class CreateTasklists < ActiveRecord::Migration
  def change
    create_table :tasklists do |t|
      t.string :name
      t.string :color, :null => false, :default => "#000000"
      
      t.timestamps
    end
  end
end
