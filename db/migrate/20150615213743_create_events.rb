class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.boolean :active
      t.string :permission

      t.timestamps null: false
    end
  end
end
