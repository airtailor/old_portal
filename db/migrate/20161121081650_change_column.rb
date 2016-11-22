class ChangeColumn < ActiveRecord::Migration
  def change
    change_column :measurements, :sleeve_length, :float
    change_column :measurements, :chest_bust, :float
    change_column :measurements, :upper_torso, :float
    change_column :measurements, :waist, :float
    change_column :measurements, :pant_length, :float
    change_column :measurements, :hips, :float
    change_column :measurements, :thigh, :float
    change_column :measurements, :knee, :float
    change_column :measurements, :calf, :float
    change_column :measurements, :ankle, :float
    change_column :measurements, :back_width, :float
    change_column :measurements, :bicep, :float
    change_column :measurements, :elbow, :float
    change_column :measurements, :forearm, :float
    change_column :measurements, :inseam, :float
  end
end


