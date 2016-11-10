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
