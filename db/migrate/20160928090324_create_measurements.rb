class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :sleeve_length
      t.integer :shoulder_to_waist
      t.integer :chest_bust
      t.integer :upper_torso
      t.integer :waist
      t.integer :pant_length
      t.integer :hips
      t.integer :thigh
      t.integer :knee
      t.integer :calf
      t.integer :ankle
      t.integer :back_width
      t.integer :bicep
      t.integer :elbow
      t.integer :forearm
      t.integer :inseam
      t.string :customer_name

      t.timestamps null: false
    end
  end
end
