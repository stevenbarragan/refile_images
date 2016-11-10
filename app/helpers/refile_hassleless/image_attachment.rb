module RefileHassleless
  module ImageAttachment
    include Refile::AttachmentHelper

    def attachment_image_tag(record, name = :file, *options, attachment: :file)
      if record.is_a?(Image)
        super(record, name, *options)
      else
        super(record.send(name), attachment, *options)
      end
    end

    module FormBuilder
      def attachment_field(method, *options)
        super("#{ method.to_s.pluralize }_files".to_sym, *options)
      end
    end

  end
end
