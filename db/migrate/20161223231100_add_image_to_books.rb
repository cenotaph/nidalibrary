class AddImageToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :image, :string
    add_column :books, :image_content_type, :string
    add_column :books, :image_size, :integer, length: 8
    add_column :books, :image_width, :integer
    add_column :books, :image_height, :integer
  end
end
