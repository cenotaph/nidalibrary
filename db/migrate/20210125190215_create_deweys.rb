class CreateDeweys < ActiveRecord::Migration[6.1]
  def change
    create_table :deweys do |t|
      t.decimal :code, precision: 12, scale: 8
      t.string :name

      t.timestamps
    end
  end
end
