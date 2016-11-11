class AddConversationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :conversation, :boolean
  end
end
