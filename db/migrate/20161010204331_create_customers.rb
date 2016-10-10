class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :unique_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :country
      t.string :zip
      t.string :phone

      t.timestamps null: false
    end
  end
end
