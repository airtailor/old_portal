class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :shopify_id
      t.string :shipment

      t.timestamps null: false
    end
  end
end
