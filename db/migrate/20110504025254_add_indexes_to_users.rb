class AddIndexesToUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :email,                :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    remove_index :users, :email
    remove_index :users, :confirmation_token
    remove_index :users, :reset_password_token
  end
end
