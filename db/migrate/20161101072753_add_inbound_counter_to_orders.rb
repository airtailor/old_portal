class AddInboundCounterToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :inbound_counter, :integer
  end
end
