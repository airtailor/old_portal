class AddShopifyIdToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :shopify_id, :string
  end
end
