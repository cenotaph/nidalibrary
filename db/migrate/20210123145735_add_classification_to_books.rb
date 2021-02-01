class AddClassificationToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :ddc, :decimal, precision: 12, scale: 8
    add_column :books, :oclc, :integer, limit: 8
    add_column :books, :lcc, :string
    add_column :books, :ddc_count, :integer
    add_column :books, :lcc_count, :integer
    add_column :books, :not_found, :boolean, null: false, default: false
  end
end
