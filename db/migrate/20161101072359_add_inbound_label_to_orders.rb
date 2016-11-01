class AddInboundLabelToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :inbound_label, :string
  end
end
