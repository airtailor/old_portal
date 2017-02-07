class AddTieAmountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :tie_amount, :string
  end
end
