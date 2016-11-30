# frozen_string_literal: true
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

      images :pictures, defaults: {
        small: "fit/20/20"
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

          expect(instance.main_image.url(:small)).to include "fit/100/100"
          expect(instance.main_image.url(:large)).to include "fill/1000/1000"
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

      describe ":association_:attachments" do
        it "builds records from assigned files" do
          instance.pictures_files = [
            Refile::FileDouble.new("hello", content_type: "image/png"),
            Refile::FileDouble.new("world", content_type: "image/png")
          ]

          expect(instance.save).to be_truthy
          expect(instance.pictures.size).to eq 2
          expect(instance.pictures[0].file_filename).to eq "pictures"
          expect(instance.pictures[0].file.read).to eq "hello"
          expect(instance.pictures[1].file.read).to eq "world"
        end

        it "set up default sizes" do
          instance.pictures_files = [
            Refile::FileDouble.new("hello", content_type: "image/png"),
            Refile::FileDouble.new("world", content_type: "image/png")
          ]

          expect(instance.pictures[0].url(:small)).to include "fit/20/20"
          expect(instance.pictures[1].url(:small)).to include "fit/20/20"
        end

        it "builds records from cache" do
          instance.pictures_files = [
            [
              { id: Refile.cache.upload(Refile::FileDouble.new("hello")).id, content_type: "image/png" },
              { id: Refile.cache.upload(Refile::FileDouble.new("world")).id, content_type: "image/png" }
            ].to_json
          ]

          expect(instance.save).to be_truthy
          expect(instance.pictures.size).to eq 2
          expect(instance.pictures[0].file_filename).to eq "pictures"
          expect(instance.pictures[0].file.read).to eq "hello"
          expect(instance.pictures[1].file.read).to eq "world"
        end
      end
    end
  end
end
