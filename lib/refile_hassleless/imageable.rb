require "active_support/concern"
require "refile"
require "refile/rails"
require "refile/attachment/active_record"

module RefileHassleless
  module Imageable
    extend ActiveSupport::Concern
    extend Refile::Attachment

    module ClassMethods

      def image(name, *options)
        attachments = :files
        plural      = name.to_s.pluralize.to_sym
        singular    = name.to_s.singularize.to_sym

        has_many plural, -> { where file_filename: singular },
          as:         :imageable,
          class_name: "Image",
          dependent:  :destroy

        accepts_attachments_for plural

        if singular == name
          alias_method :"#{ name }_attachment_definition", :"#{ plural }_#{ attachments }_attachment_definition"
          alias_method :"#{ name }_data", :"#{ plural }_#{ attachments }_data"

          define_method name do
            send(plural).last
          end
        end

        image_options[name] = options.first

        define_method :"#{ plural }_#{ attachments }=" do |files|
          files = (files.is_a?(String) ? [files] : files).map do |file|
            file = Refile.parse_json(file, symbolize_names: true)

            (file.is_a?(Array) ? file : [file] ).map do |file|
              file.merge(filename: singular)
            end.to_json
          end

          super(files)
        end
      end

      alias_method :images, :image

      def image_options
        @image_options ||= {}
      end
    end

    def images
      @images ||= OpenStruct.new(images_hash)
    end

    def images_hash
      self.class.image_options.inject({}) do |images, (name, sizes)|
        send(name).tap do |image|
          images[name] = if image.respond_to? :each
             image.map do |img|
               image_hash(img, sizes)
             end
           else
             image_hash(image, sizes)
           end
        end

      images

      end
    end

    def image_hash(image, sizes)
      sizes.inject({}) do |setup, (name, config)|
        setup.merge(
          name => Refile.attachment_url(image, :file, config)
      )
      end
    end
  end
end
