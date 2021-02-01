class CreateCutters < ActiveRecord::Migration[6.1]
  def change
    create_table :cutters do |t|
      t.integer :num
      t.string :str

      t.timestamps
    end
  end
end
