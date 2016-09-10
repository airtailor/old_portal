class AddCustomerToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :customer, :string
  end
end
