class AddOrderIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :order_id, :string
  end
end
