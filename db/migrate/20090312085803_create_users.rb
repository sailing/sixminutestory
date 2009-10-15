class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login
      t.string :crypted_password
      t.string :password_salt
      t.string :website
      t.string :email_address
      t.text :profile
      t.boolean :active, :default => 1
      t.integer :admin_level, :default => 1
      
      
      t.string :persistence_token
      t.integer :login_count
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
