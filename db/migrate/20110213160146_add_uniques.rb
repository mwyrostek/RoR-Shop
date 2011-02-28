class AddUniques < ActiveRecord::Migration
  def self.up
    add_index :users, :login, :uniaue => true
    add_index :users, :email, :unique => true
  end

  def self.down
    remove_index :users, :login
    remove_index :users, :email
  end
end
