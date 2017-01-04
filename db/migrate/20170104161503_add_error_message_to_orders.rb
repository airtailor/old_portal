class AddErrorMessageToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :error_message, :string
  end
end
