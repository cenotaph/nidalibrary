class CreateCollections < ActiveRecord::Migration[6.1]
  def change
    create_table :collections do |t|
      t.string :name
      t.boolean :active, default: true, null: false
      t.decimal :number
      t.string :slug
      t.timestamps
    end

    add_reference :books, :collection, foreign_key: true
  end
end
