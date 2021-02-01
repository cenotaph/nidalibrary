class AddIdToBooksFasts < ActiveRecord::Migration[6.1]
  def change
    add_column :books_fasts, :id, :primary_key
  end
end
