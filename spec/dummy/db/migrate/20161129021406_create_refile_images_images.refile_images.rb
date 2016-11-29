# This migration comes from refile_images (originally 20161107201317)
# frozen_string_literal: true
class CreateRefileImagesImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string  :file_id
      t.string  :file_filename
      t.integer :file_size
      t.string  :file_content_type

      t.references :imageable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
