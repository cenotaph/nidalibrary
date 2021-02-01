class AddIsEditorToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :author_is_editor, :boolean, default: false, null: false
    add_column :books, :author_is_institution, :boolean, default: false, null: false
  end
end
