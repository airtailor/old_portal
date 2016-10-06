class AddArrivalDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :arrival_date, :datetime
  end
end
