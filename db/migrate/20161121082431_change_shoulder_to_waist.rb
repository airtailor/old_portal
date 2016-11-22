class ChangeShoulderToWaist < ActiveRecord::Migration
  def change
    change_column :measurements, :shoulder_to_waist, :float
  end
end
