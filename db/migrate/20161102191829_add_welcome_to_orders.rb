class AddWelcomeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :welcome, :boolean
  end
end
