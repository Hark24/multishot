class Photo < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  
  has_attached_file :images, styles: {:original => "1280x1280"}
  validates_attachment_content_type :images, content_type: /image/

  def orientation
    begin
      images.height < images.width ? "landscape" : "portrait"
    rescue
      "portrait"
    end
  end
end
