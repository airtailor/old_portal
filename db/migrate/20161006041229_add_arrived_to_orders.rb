class AddArrivedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :arrived, :boolean
  end
end
