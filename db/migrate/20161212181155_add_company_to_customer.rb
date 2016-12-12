class AddCompanyToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :company, :string
  end
end
