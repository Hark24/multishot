class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :state

      t.timestamps null: false
    end
  end
end
