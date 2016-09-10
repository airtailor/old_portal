class AddOrderIdToAlterations < ActiveRecord::Migration
  def change
    add_reference :alterations, :order, index: true, foreign_key: true
  end
end
