class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :business_name
      t.string :user_name
      t.string :phone
      t.string :street
      t.string :unit
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :timezone

      t.timestamps null: false
    end
    add_index :users, :email
  end
end
