class AddCompleteToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :complete, :boolean
  end
end
