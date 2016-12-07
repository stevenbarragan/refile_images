# frozen_string_literal: true
require "active_support/concern"
require "refile"
require "refile/rails"
require "refile/attachment/active_record"

module RefileImages
  module Imageable
    extend ActiveSupport::Concern
    extend Refile::Attachment

    module ClassMethods
      def image(name, attachment: :file, append: false, defaults: {})
        attachments = attachment.to_s.pluralize.to_sym
        plural      = name.to_s.pluralize.to_sym
        singular    = name.to_s.singularize.to_sym

        has_many plural, -> { where "#{attachment}_filename" => name },
          as:         :imageable,
          class_name: "Image",
          dependent:  :destroy,
          inverse_of: :imageable

        accepts_attachments_for plural, attachment: attachment, append: append

        if singular == name
          alias_method :"#{ name }_attachment_definition", :"#{ plural }_#{ attachments }_attachment_definition"
          alias_method :"#{ name }_data", :"#{ plural }_#{ attachments }_data"

          define_method name do
            send(plural).last
          end

          define_method :"#{ name }=" do |file|
            file = "[#{file}]" if file.is_a?(String) && !file.match(/^\[/)

            send("#{plural}_#{attachments}=", [file])
          end

          define_method :"#{ name }_url" do |*args|
            send(name).send("#{attachment}_url", *args)
          end
        end

        image_options[name] = defaults

        define_method :"#{ plural }_#{ attachments }=" do |files|
          cache, files = files.partition { |file| file.is_a?(String) }

          cache = Refile.parse_json(cache.first)

          if not append and (files.present? or cache.present?)
            send("#{plural}=", [])
          end

          if files.empty? and cache.present?
            cache.select(&:present?).each do |file|
              send(plural).build(
                attachment => file.to_json,
                "#{attachment}_filename" => name
              )
            end
          else
            files.select(&:present?).each do |file|
              send(plural).build(
                attachment => file,
                "#{attachment}_filename" => name
              )
            end
          end
        end
      end

      alias images image

      def image_options
        @image_options ||= {}
      end
    end

    def get_url(image, size, *options)
      Refile.attachment_url(
        image,
        :file,
        image_config(image.file_filename)[size],
        *options
      )
    end

  private

    def image_config(name)
      self.class.image_options[name.to_sym]
    end
  end
end
