class AddForeignKeysToInvitations < ActiveRecord::Migration
  def change
    add_reference :invitations, :user, index: true
    add_foreign_key :invitations, :users
    add_reference :invitations, :event, index: true
    add_foreign_key :invitations, :events
  end
end
