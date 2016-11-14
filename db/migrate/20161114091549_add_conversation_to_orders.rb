class AddConversationToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :conversation, :boolean
  end
end
