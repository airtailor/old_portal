class DropSomeTables < ActiveRecord::Migration
  def change
    drop_table :alterations
    drop_table :items
    drop_table :orders 
  end
end
