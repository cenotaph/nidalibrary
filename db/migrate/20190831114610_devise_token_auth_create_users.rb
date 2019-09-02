class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :provider, :string, :null => false, :default => "email"
    add_column :users, :uid, :string, :null => false, :default => ""

    add_column :users, :allow_password_change, :boolean, :default => false
    add_column :users, :name, :string
    add_column :users, :nickname, :string
    add_column :users, :image, :string

    add_column :users, :tokens, :text


    # add_index :users, :email,                unique: true
    # add_index :users, [:uid, :provider],     unique: true
    # add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,       unique: true
  end
end
