class AddUserReadToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :user_read, :boolean
  end
end
