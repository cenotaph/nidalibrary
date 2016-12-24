class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :isbn10
      t.string :isbn13
      t.string :title, limit: 512
      t.string :language
      t.string :publisher
      t.integer :pages
      t.integer :year_published
      t.string :author, limit: 512
      t.string :subtitle
      t.text :comment
      t.string :catno
      t.string :provenance
      t.string :slug, limit: 512

      t.timestamps
    end
  end
end
