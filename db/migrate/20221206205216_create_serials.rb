class CreateSerials < ActiveRecord::Migration[7.0]
  def change
    create_table :serials do |t|
      t.string :title
      t.string :volume
      t.string :number
      t.string :issn
      t.integer :year
      t.string :month
      t.string :language
      t.string :subtitle
      t.string :publisher
      t.string :provenance
      t.text :comment
      t.string :image
      t.string :image_content_type
      t.integer :image_size, length: 8
      t.integer :image_width
      t.integer :image_height
      t.integer :status_id
      t.integer :copies
      t.timestamps
    end
  end
end
