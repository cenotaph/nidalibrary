class AddBooksCountToFasts < ActiveRecord::Migration[6.1]
  def self.up
    remove_column :books_fasts, :books_count
    add_column :fasts, :books_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :fasts, :books_count
    add_column :books_fasts, :books_count, :integer, null: false, default: 0
  end
end
