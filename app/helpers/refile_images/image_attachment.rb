# frozen_string_literal: true
module RefileImages
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
      def attachment_field(method, **options)
        super(method, options.reverse_merge(direct: true))
      end
    end
  end
end
