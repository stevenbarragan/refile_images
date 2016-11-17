class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  attachment :file, type: :image

  def url_for(size, *options)
    imageable.get_image_url(self, size, *options)
  end
end
