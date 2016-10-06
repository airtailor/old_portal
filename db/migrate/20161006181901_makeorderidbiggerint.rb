class Makeorderidbiggerint < ActiveRecord::Migration
  def change
    change_column :orders, :shopify_id, :string
    change_column :orders, :unique_id, :string
  end
end
