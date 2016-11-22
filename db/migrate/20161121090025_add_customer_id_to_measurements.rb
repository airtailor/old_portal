class AddCustomerIdToMeasurements < ActiveRecord::Migration
  def change
    add_column :measurements, :customer_id, :string
  end
end
