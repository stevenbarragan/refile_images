require "rails_helper"
require "refile"
require "refile/file_double"

describe RefileImages::Imageable do
  describe ".image" do
    klass = Class.new(ActiveRecord::Base) do
      self.table_name = :posts

      def self.name
        "Post"
      end

      image :main_image, {
        small: "fit/100/100"
      }
    end

    describe klass, type: :model do
      it { should have_many(:main_images).conditions(file_filename: :main_image) }

      it { should respond_to :main_image }
      it { should respond_to :main_image_attachment_definition }
      it { should respond_to :main_image_data }

      it do
        subject.main_images_files = {id: "IMAGEID", content_type: "image/jpeg", size: 1234}.to_json

        subject.save

        expect(subject.main_image).to be_present
        expect(subject.main_image.file_filename).to eq "main_image"
      end
    end
  end
end
