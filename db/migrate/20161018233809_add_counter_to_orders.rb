class AddCounterToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :counter, :integer
  end
end
