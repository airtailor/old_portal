class AddOrderIdToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :order_id, :string
  end
end
