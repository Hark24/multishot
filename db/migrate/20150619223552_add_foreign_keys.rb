class AddForeignKeys < ActiveRecord::Migration
  def change
  	add_reference :events, :user, index: true
  	add_foreign_key :events, :users
  	add_reference :photos, :event, index: true
  	add_foreign_key :photos, :events
  end
end
