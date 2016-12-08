# frozen_string_literal: true
class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  attachment :file, type: :image

  def url(size, *options)
    imageable.get_url(self, size, *options)
  end


  # Generate a custom image URL.
  #
  # If the filename option is not given, the filename is taken from the
  # metadata stored in the attachment, or eventually falls back to the
  # `name`.
  #
  # The host defaults to {Refile.cdn_host}, which is useful for serving all
  # attachments from a CDN. You can also override the host via the `host`
  # option.
  #
  # @example original image url
  #   image.custom_url
  #
  # @example With custom params
  #   image.attachment_url(:fill, 300, 300, format: :jpg, filename: "awesome")
  #
  # @param [String, nil] filename        The filename to be appended to the URL
  # @param [String, nil] format          A file extension to be appended to the URL
  # @param [String, nil] host            Override the host
  # @param [String, nil] prefix          Adds a prefix to the URL if the application is not mounted at root
  # @return [String, nil]                The generated URL
  def custom_url(*args, **options)
    Refile.attachment_url(self, :file, *args, **options)
  end
end
