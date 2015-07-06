class AddImageColumnsToPhotos < ActiveRecord::Migration
def up
    add_attachment :photos, :images
  end

  def down
    remove_attachment :photos, :images
  end
end
