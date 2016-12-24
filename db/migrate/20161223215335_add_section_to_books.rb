class AddSectionToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :section_id, :integer
    add_index :books, :section_id
  end
end
