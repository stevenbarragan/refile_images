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

      image :main_image, defaults: {
        small: "fit/100/100",
        large: "fill/1000/1000"
      }
    end

    let(:instance) { klass.new }

    describe klass, type: :model do
      it { should have_many(:main_images).conditions(file_filename: :main_image) }
      it { should respond_to :main_image }
      it { should respond_to :main_image_attachment_definition }
      it { should respond_to :main_image_data }

      describe ":image=" do
        it "stores :image correctly" do
          instance.main_image = Refile::FileDouble.new("hello", content_type: "image/png")

          expect(instance.save).to be_truthy
          expect(instance.main_image.file_filename).to eq "main_image"
        end

        it "set up default sizes" do
          instance.main_image = Refile::FileDouble.new("hello", content_type: "image/png")

          expect(instance.main_image.url_for :small).to include "fit/100/100"
          expect(instance.main_image.url_for :large).to include "fill/1000/1000"
        end

        it "receives serialized data and retrieves file from it" do
          file = Refile.cache.upload(Refile::FileDouble.new("hello"))

          instance.main_image = { id: file.id, filename: "foo.txt", content_type: "image/png", size: 5 }.to_json

          expect(instance.save).to be_truthy
          expect(instance.main_image.file_filename).to eq "main_image"
          expect(instance.main_image.file_content_type).to eq "image/png"
          expect(instance.main_image.file_size).to eq 5
        end

      end
    end
  end
end
