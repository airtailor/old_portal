class AddShippingLabelToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_label, :string
  end
end
