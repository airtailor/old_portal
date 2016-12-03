class AddTailorNotesToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :tailor_notes, :text
  end
end
