class AddImagesMetaToPhotos < ActiveRecord::Migration
  def change
  	add_column :photos, :images_meta, :text
  end
end