class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
    	t.integer :user_1_id, :null => false
      t.integer :user_2_id, :null => false
      t.boolean :confirm

      t.timestamps null: false
    end
  end
end
