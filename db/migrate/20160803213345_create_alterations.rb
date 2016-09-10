class CreateAlterations < ActiveRecord::Migration
  def change
    create_table :alterations do |t|
      t.references :item, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true
      t.string :alteration

      t.timestamps null: false
    end
  end
end
