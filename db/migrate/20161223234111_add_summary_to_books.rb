class AddSummaryToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :summary, :text
  end
end
