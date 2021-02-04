class AddArtistToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :artist, :string
  end
end
