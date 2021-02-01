class AddContributorToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :contributors, :string
  end
end
