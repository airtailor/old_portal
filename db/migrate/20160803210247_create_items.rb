class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :order, index: true, foreign_key: true
      t.string :item_name
      t.string :notes

      t.timestamps null: false
    end
  end
end
