class CreateJoinTableBookFast < ActiveRecord::Migration[6.1]
  def change
    create_join_table :books, :fasts do |t|
      # t.index [:book_id, :fast_id]
      # t.index [:fast_id, :book_id]
    end
  end
end
