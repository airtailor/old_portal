class AddUniquenessToEmail < ActiveRecord::Migration
  def change
    change_column(:users, :email, :string, unique: true)
  end
end
