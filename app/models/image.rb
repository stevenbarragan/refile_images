# frozen_string_literal: true
class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  attachment :file, type: :image

  def url(size, *options)
    imageable.get_url(self, size, *options)
  end
end
