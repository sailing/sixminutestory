class AddAdminColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :admin_level, :integer
  end

  def self.down
    remove_column :users, :column_name
  end
end
