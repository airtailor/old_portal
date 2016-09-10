class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :sender_id
      t.string :recipient_id

      t.timestamps null: false
    end
  end
end
