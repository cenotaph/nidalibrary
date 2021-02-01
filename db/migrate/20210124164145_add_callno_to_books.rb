class AddCallnoToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :call_number, :string
    add_column :books, :copies, :integer, default: 1, null: false
  end
end
