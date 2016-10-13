class Addweighttoordertable < ActiveRecord::Migration
  def change
    add_column :orders, :weight, :string
  end
end
