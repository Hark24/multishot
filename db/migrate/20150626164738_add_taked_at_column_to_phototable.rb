class AddTakedAtColumnToPhototable < ActiveRecord::Migration
  def change
  	add_column :photos, :taked_at, :datetime
  end
end
