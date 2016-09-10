class NewOrderTable < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.integer :shopify_id
      t.integer :unique_id
      t.string :total
      t.string :alterations
      t.references :user, index: true, foreign_key: true
    end
  end
end
