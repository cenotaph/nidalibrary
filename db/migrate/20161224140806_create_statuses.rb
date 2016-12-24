class CreateStatuses < ActiveRecord::Migration[5.0]
  def self.up
    create_table :statuses do |t|
      t.string :name
      t.string :colour, limit: 7
      t.string :slug

      t.timestamps
    end
    Status.create(name: 'On shelf', colour: '#333333')
    Status.create(name: 'Borrowed', colour: '#aaaacc')
    Status.create(name: 'Missing', colour: '#FF2222')
    add_column :books, :status_id, :integer, default: 1, null: false
    add_index :books, :status_id
  end
  
  def self.down
    drop_table :statuses
    remove_column :books, :status_id
  end
end
