class AddFulfillDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :fulfill_date, :datetime
  end
end
