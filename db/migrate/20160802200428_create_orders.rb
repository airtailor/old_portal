class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :date_received
      t.datetime :date_sent
      t.string :status

      t.timestamps null: false
    end
  end
end
